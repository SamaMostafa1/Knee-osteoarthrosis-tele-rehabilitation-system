import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.utils import shuffle
from sklearn.model_selection import train_test_split

from sklearn.metrics import classification_report, accuracy_score, precision_score, recall_score, f1_score, confusion_matrix, roc_auc_score, mean_squared_error


import warnings
warnings.filterwarnings('ignore')

from sklearn import metrics

import random
random_seed = 1234
random.seed(random_seed)
np.random.seed(random_seed)


def read_csv_file(file_path):
    try:
        return pd.read_csv(file_path, encoding='utf-8')
    except UnicodeDecodeError:
        return pd.read_csv(file_path, encoding='latin1')

def MergeTwoDataFrame(df1, df2, col_name):
    # Get the count of trials per patient
    trials_counts = df1[col_name].value_counts().to_dict()
    # print("trials:", trials_counts)
    # Expand the anthropometric data
    expanded_wdf = df2.loc[
        df2.index.repeat(df2[col_name].map(trials_counts))
    ].reset_index(drop=True)
    merged_df = pd.merge(df1, df2, on = col_name, how = 'left')
    if (df1.shape[0] == merged_df.shape[0]):
        print("Merged succesfully")
    return merged_df

def MissingValueHandling(df):
    null_col =  dict(df.isnull().sum()) 
    missing_data = []
    for key, value in null_col.items():
        if (value != 0):
            missing_data.append(key) 
    # print("Missing Values Column:", null_col)
    print("the columns that contain null values:", missing_data)
    for i in missing_data:
        fill_list = df[i].dropna().tolist()
        df[i] = df[i].fillna(pd.Series(np.random.choice(fill_list , size = len(df.index))))
    if not df.isnull().values.any():
        print("Missing values handled")
    else:
        print("There are missing values in the DataFrame.")
    return df

def Encoding(df):
    # Create the ncoder variable
    encoder = LabelEncoder()
    cat_df = df.select_dtypes(include=['object'])
    for i in cat_df:
        # fit the categoral feature to the encoding method
        df[i] = encoder.fit_transform(df[i]) 
    return df

def correlation(dataset, threshold):
    col_corr = set()  # Set of all the names of correlated columns
    corr_matrix = dataset.corr()
    for i in range(len(corr_matrix.columns)):
        for j in range(i):
            if abs(corr_matrix.iloc[i, j]) > threshold: # we are interested in absolute coeff value
                colname = corr_matrix.columns[i]  # getting the name of column
                col_corr.add(colname)
    return col_corr


def PlottingfeatureImportance(features, score, x_label, y_label, title):
    # Plot feature importance
    plt.figure(figsize=(12, 12))
    plt.barh(features, score, color='teal')
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.title(title)
    plt.gca().invert_yaxis()  # To display the highest scores at the top
    # Save the plot as an image
    # plt.savefig('important_img/Gain_feature_importance.png', format='png', dpi=300, bbox_inches='tight')
    plt.show()

def DropAfterFeatureSelection(mi_scores_df, X_train, X_test):
    non_selected_features = []
    for i in range(len(mi_scores_df["Feature"])):
        # print(mi_scores_df["Feature"][i])
        if mi_scores_df["MI Score"][i] == 0.000000:
            non_selected_features.append(mi_scores_df["Feature"][i])
    print("the droped columns", non_selected_features)
    X_train = X_train.drop(non_selected_features, axis=1)
    X_test = X_test.drop(non_selected_features, axis=1)
    return X_train, X_test

def ScalingData(X_train, X_test):
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    return X_train_scaled, X_test_scaled

# Function to train and evaluate models
def train_and_evaluate(model, model_name, X_train_scaled, y_train, X_test_scaled, y_test):
    model.fit(X_train_scaled, y_train)
    y_pred = model.predict(X_test_scaled)
    train_accuracy = round(model.score(X_train_scaled, y_train) * 100, 2)
    test_accuracy = round(model.score(X_test_scaled, y_test) * 100, 2)
    f1 = f1_score(y_test, y_pred, average='weighted')
    rmse = np.sqrt(mean_squared_error(y_test, y_pred))
    # accuracy = accuracy_score(y_test, y_pred)
    # print(f"{model_name} Training Accuracy: {train_accuracy:.2f}")
    # print(f"{model_name} Testing Accuracy: {test_accuracy:.2f}")
    # print(f"{model_name} Model Accuracy: {accuracy:.2f}")
    return y_pred, train_accuracy, test_accuracy, f1, rmse

def Evaluate(X_train_scaled, y_train, X_test_scaled, y_test, y_pred):
    results = {}
    results['train_accuracy'] = round(model.score(X_train_scaled, y_train) * 100, 2)
    results['test_accuracy'] = round(model.score(X_test_scaled, y_test) * 100, 2)
    results['f1'] = f1_score(y_test, y_pred, average='weighted')
    results['rmse'] = np.sqrt(mean_squared_error(y_test, y_pred))
    return results


def evaluate_classification_model(model, X_test, y_test):
    # Make predictions on the test set
    y_pred = model.predict(X_test)

    # Compute evaluation metrics
    accuracy = accuracy_score(y_test, y_pred)
    precision = precision_score(y_test, y_pred, average='weighted')
    recall = recall_score(y_test, y_pred, average='weighted')
    f1 = f1_score(y_test, y_pred, average='weighted')
    cm = confusion_matrix(y_test, y_pred)

    # Print the evaluation metrics
    print("Precision:", precision)
    print("Recall:", recall)
    print("F1-score:", f1)

    # Plot the confusion matrix
    labels = np.unique(y_test)
    sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', xticklabels=labels, yticklabels=labels)
    plt.title('Confusion Matrix')
    plt.xlabel('Predicted Label')
    plt.ylabel('True Label')
    plt.show()



def cmatrix_fun(model_name, actual, predicted):
    # Compute confusion matrix
    cm = metrics.confusion_matrix(actual, predicted)
    
    # Normalize confusion matrix
    cm_normalized = (cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]) * 100
    
    # Plot the normalized confusion matrix
    fig, ax = plt.subplots(figsize=(6, 6))
    class_labels = ['normal', 'mild', 'moderate', 'severe']
    im = ax.imshow(cm_normalized, interpolation='nearest', cmap='Blues')
    
    # Add colorbar
    cbar = ax.figure.colorbar(im, ax=ax)
    cbar.ax.set_ylabel('Percentage', rotation=-90, va="bottom")
    
    # Show all ticks and label them with the respective list entries
    ax.set(xticks=np.arange(cm.shape[1]),
           yticks=np.arange(cm.shape[0]),
           xticklabels=class_labels, yticklabels=class_labels,
           title=model_name,
           ylabel='True label',
           xlabel='Predicted label')
    
    # Rotate the tick labels and set their alignment.
    plt.setp(ax.get_xticklabels(), ha="right",
             rotation_mode="anchor")
    
    # Loop over data dimensions and create text annotations.
    fmt = '.2f'  # Format for the percentages
    thresh = cm_normalized.max() / 2.
    for i in range(cm.shape[0]):
        for j in range(cm.shape[1]):
            ax.text(j, i, format(cm_normalized[i, j], fmt),
                    ha="center", va="center",
                    color="white" if cm_normalized[i, j] > thresh else "black")
    
    plt.show()




