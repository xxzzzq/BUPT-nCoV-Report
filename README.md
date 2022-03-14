## **警告**
**使用本工具及其衍生品即代表使用者将承担自己行为后果的全部责任。**

**作者并不提供任何保证，甚至是基本可用性的保证。**

# BUPT-nCoV-Report
## 北京邮电大学疫情防控打卡

使用 GitHub Actions 定时打卡。  
目前支持晨午晚检，后续可能增加功能。  
欢迎 Issue 和 PR.

## 注意事项
- 在使用前**需要手动进行（至少）一次打卡**
- Fork 后可能**需要手动启动 GitHub Actions**
- 上游 repo 更新后，（如果没有破坏性更新）只需要拉取最新状态即可

## 使用方法
0. Fork 本仓库
0. 在你 Fork 的仓库的 Settings 的 Secrets 中设置以下信息:
- `IS_AT_SCHOOL`: 0或1，是否在校
- `BUPT_USERNAME`: 学号
- `BUPT_PASSWORD`: 密码

## 失败警告
如果打卡失败，GitHub 会发邮件到你的邮箱。
