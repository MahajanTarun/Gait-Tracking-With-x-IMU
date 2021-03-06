# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'layouts/base.ui'
#
# Created by: PyQt5 UI code generator 5.6
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(800, 600)
        MainWindow.setLocale(QtCore.QLocale(QtCore.QLocale.English, QtCore.QLocale.UnitedStates))
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout(self.centralwidget)
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.verticalLayout_Graph = QtWidgets.QVBoxLayout()
        self.verticalLayout_Graph.setObjectName("verticalLayout_Graph")
        self.graph = PlotWidget(self.centralwidget)
        self.graph.setObjectName("graph")
        self.verticalLayout_Graph.addWidget(self.graph)
        self.lbl_StatusGraph = QtWidgets.QLabel(self.centralwidget)
        self.lbl_StatusGraph.setObjectName("lbl_StatusGraph")
        self.verticalLayout_Graph.addWidget(self.lbl_StatusGraph)
        self.horizontalLayout_2.addLayout(self.verticalLayout_Graph)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 800, 28))
        self.menubar.setObjectName("menubar")
        self.menuFile = QtWidgets.QMenu(self.menubar)
        self.menuFile.setObjectName("menuFile")
        self.menuView = QtWidgets.QMenu(self.menubar)
        self.menuView.setObjectName("menuView")
        self.menuHelp = QtWidgets.QMenu(self.menubar)
        self.menuHelp.setObjectName("menuHelp")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)
        self.dockWidget_Options = QtWidgets.QDockWidget(MainWindow)
        self.dockWidget_Options.setMinimumSize(QtCore.QSize(128, 145))
        font = QtGui.QFont()
        font.setBold(False)
        font.setWeight(50)
        self.dockWidget_Options.setFont(font)
        self.dockWidget_Options.setFloating(False)
        self.dockWidget_Options.setFeatures(QtWidgets.QDockWidget.AllDockWidgetFeatures)
        self.dockWidget_Options.setObjectName("dockWidget_Options")
        self.dockWidgetContents_Options = QtWidgets.QWidget()
        self.dockWidgetContents_Options.setObjectName("dockWidgetContents_Options")
        self.verticalLayout = QtWidgets.QVBoxLayout(self.dockWidgetContents_Options)
        self.verticalLayout.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout.setObjectName("verticalLayout")
        self.btnStart = QtWidgets.QPushButton(self.dockWidgetContents_Options)
        self.btnStart.setObjectName("btnStart")
        self.verticalLayout.addWidget(self.btnStart)
        self.btnA = QtWidgets.QPushButton(self.dockWidgetContents_Options)
        self.btnA.setObjectName("btnA")
        self.verticalLayout.addWidget(self.btnA)
        self.btnB = QtWidgets.QPushButton(self.dockWidgetContents_Options)
        self.btnB.setObjectName("btnB")
        self.verticalLayout.addWidget(self.btnB)
        spacerItem = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.verticalLayout.addItem(spacerItem)
        self.dockWidget_Options.setWidget(self.dockWidgetContents_Options)
        MainWindow.addDockWidget(QtCore.Qt.DockWidgetArea(1), self.dockWidget_Options)
        self.dockWidget_Communication = QtWidgets.QDockWidget(MainWindow)
        self.dockWidget_Communication.setEnabled(True)
        self.dockWidget_Communication.setFloating(False)
        self.dockWidget_Communication.setObjectName("dockWidget_Communication")
        self.dockWidgetContents_Com = QtWidgets.QWidget()
        self.dockWidgetContents_Com.setObjectName("dockWidgetContents_Com")
        self.verticalLayout_2 = QtWidgets.QVBoxLayout(self.dockWidgetContents_Com)
        self.verticalLayout_2.setContentsMargins(0, 0, 0, 0)
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.lblSerialPortTitle = QtWidgets.QLabel(self.dockWidgetContents_Com)
        font = QtGui.QFont()
        font.setBold(True)
        font.setWeight(75)
        self.lblSerialPortTitle.setFont(font)
        self.lblSerialPortTitle.setObjectName("lblSerialPortTitle")
        self.verticalLayout_2.addWidget(self.lblSerialPortTitle)
        self.cbSerialPort = QtWidgets.QComboBox(self.dockWidgetContents_Com)
        self.cbSerialPort.setObjectName("cbSerialPort")
        self.verticalLayout_2.addWidget(self.cbSerialPort)
        self.cbBaudRates = QtWidgets.QComboBox(self.dockWidgetContents_Com)
        self.cbBaudRates.setObjectName("cbBaudRates")
        self.verticalLayout_2.addWidget(self.cbBaudRates)
        self.btnConnect = QtWidgets.QPushButton(self.dockWidgetContents_Com)
        self.btnConnect.setObjectName("btnConnect")
        self.verticalLayout_2.addWidget(self.btnConnect)
        spacerItem1 = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.verticalLayout_2.addItem(spacerItem1)
        self.dockWidget_Communication.setWidget(self.dockWidgetContents_Com)
        MainWindow.addDockWidget(QtCore.Qt.DockWidgetArea(1), self.dockWidget_Communication)
        self.actionAbout = QtWidgets.QAction(MainWindow)
        self.actionAbout.setObjectName("actionAbout")
        self.actionTutorial = QtWidgets.QAction(MainWindow)
        self.actionTutorial.setObjectName("actionTutorial")
        self.actionOptions_Menu = QtWidgets.QAction(MainWindow)
        self.actionOptions_Menu.setCheckable(True)
        self.actionOptions_Menu.setChecked(True)
        self.actionOptions_Menu.setObjectName("actionOptions_Menu")
        self.actionOpen = QtWidgets.QAction(MainWindow)
        self.actionOpen.setObjectName("actionOpen")
        self.actionSave = QtWidgets.QAction(MainWindow)
        self.actionSave.setObjectName("actionSave")
        self.actionNew = QtWidgets.QAction(MainWindow)
        self.actionNew.setObjectName("actionNew")
        self.actionClose = QtWidgets.QAction(MainWindow)
        self.actionClose.setObjectName("actionClose")
        self.actionQuit = QtWidgets.QAction(MainWindow)
        self.actionQuit.setObjectName("actionQuit")
        self.actionCommunication_Menu = QtWidgets.QAction(MainWindow)
        self.actionCommunication_Menu.setCheckable(True)
        self.actionCommunication_Menu.setChecked(True)
        self.actionCommunication_Menu.setObjectName("actionCommunication_Menu")
        self.menuFile.addAction(self.actionNew)
        self.menuFile.addAction(self.actionOpen)
        self.menuFile.addAction(self.actionSave)
        self.menuFile.addSeparator()
        self.menuFile.addAction(self.actionClose)
        self.menuFile.addSeparator()
        self.menuFile.addAction(self.actionQuit)
        self.menuView.addAction(self.actionOptions_Menu)
        self.menuView.addAction(self.actionCommunication_Menu)
        self.menuHelp.addAction(self.actionTutorial)
        self.menuHelp.addSeparator()
        self.menuHelp.addAction(self.actionAbout)
        self.menubar.addAction(self.menuFile.menuAction())
        self.menubar.addAction(self.menuView.menuAction())
        self.menubar.addAction(self.menuHelp.menuAction())

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)
        MainWindow.setTabOrder(self.graph, self.btnStart)
        MainWindow.setTabOrder(self.btnStart, self.btnA)
        MainWindow.setTabOrder(self.btnA, self.btnB)
        MainWindow.setTabOrder(self.btnB, self.cbSerialPort)
        MainWindow.setTabOrder(self.cbSerialPort, self.cbBaudRates)
        MainWindow.setTabOrder(self.cbBaudRates, self.btnConnect)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "Real Time Gait Tracking"))
        self.lbl_StatusGraph.setText(_translate("MainWindow", "Status Buffers:"))
        self.menuFile.setTitle(_translate("MainWindow", "File"))
        self.menuView.setTitle(_translate("MainWindow", "View"))
        self.menuHelp.setTitle(_translate("MainWindow", "Help"))
        self.dockWidget_Options.setWindowTitle(_translate("MainWindow", "Options"))
        self.btnStart.setText(_translate("MainWindow", "S"))
        self.btnA.setText(_translate("MainWindow", "A"))
        self.btnB.setText(_translate("MainWindow", "B"))
        self.dockWidget_Communication.setWindowTitle(_translate("MainWindow", "Communication"))
        self.lblSerialPortTitle.setText(_translate("MainWindow", "Porta Serial:"))
        self.btnConnect.setText(_translate("MainWindow", "Connect"))
        self.actionAbout.setText(_translate("MainWindow", "About"))
        self.actionTutorial.setText(_translate("MainWindow", "Help"))
        self.actionOptions_Menu.setText(_translate("MainWindow", "Options Menu"))
        self.actionOpen.setText(_translate("MainWindow", "Open"))
        self.actionSave.setText(_translate("MainWindow", "Save"))
        self.actionNew.setText(_translate("MainWindow", "New"))
        self.actionClose.setText(_translate("MainWindow", "Close"))
        self.actionQuit.setText(_translate("MainWindow", "Quit"))
        self.actionCommunication_Menu.setText(_translate("MainWindow", "Communication Menu"))

from pyqtgraph import PlotWidget
