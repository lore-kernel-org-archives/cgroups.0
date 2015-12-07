From: Ankur Khurana <ankur.kkhurana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Thread page cache getting accounted in the process cgroup instead of
 cgroup assigned to the thread.
Date: Mon, 7 Dec 2015 16:06:18 +0530
Message-ID: <CAKpF0T6+N1TimuKePhXKN4Z+Zmz=NKuOURP3bi0GPC7EZMJurg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=Po8P+DiLrWzJfwpu5pwMN8UPb84WDkAn+xn/PfHQlbs=;
        b=dnyn5Lua6W+aiQ0PSLWfR++MO6hTwQH+o81AR9WNVq3eUgGm0BMc9IxsXw/4a7J9i9
         zRKkCayp+7OzYF6VkMMyEjy3i2e4IjK9hiCUYrcM5lhc2YaoTiCeKtLFCDHwyhhBa/Ni
         7lViXXk9WZpY8lv5Dyj7Tsxlu1phmP+LihRD43uHPCVlYDnH95R/AiRdDHuJz9TXCgNo
         TzXlgMaxfDocmEBP7Ib2DurT1OTadYPHy8eZiZj2TVXF28IHzBAbnZhD3tMi6c8Wt+7W
         S7r+RtdKiUUBVuHmeYdzqaOQuvw+qGvCTYZK1arqTy3MgDUudjxpZE1mFC1bHl3/ikVW
         ubqQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Recently, I got to know about the control groups on linux and found it
interesting and started experimenting with it. I tried cgroups for
various subsystems and it worked as I would expect it to work. Feeling
empowered with the use of control groups, I went one step further and
tried to get resource isolation on thread level. I used java as a
choice of programming language and tried to do resource allocation to
different threads. It worked really fine for cpu and blkio but results
for memory were somewhat interesting.

To test memory subsystem and as I also wanted to test the impact of
subsystem on page cache, What I did was to start the program in a
control group names Parent_cgroup in memory subsystem. After that, I
launched two threads and assigned Child_cgroup_1 and Child_cgroup_2 to
thread 1 and thread 2 respectively where Child_cgroup_1 and
Child_cgroup_2 are children of parent_cgroup.


Hierarchy looks something like this :

                          root
                          /
                  Parent_cgroup
                  /                    \
  Child_cgroup_1         Child_cgroup_2


thread 1 belongs to Child_cgroup_1
thread 2 belongs to Child_cgroup_2
the test was started in Parent_cgroup.


Now, the thread 1 and thread 2 starts reading different file from
disk. e.g. thread1 is reading file1 and thread 2 is reading file 2 .
Both the files are 100mb files and are being read in a loop i.e. if
the file ends, the thread start reading the file from the start. After
sometime , when the file has been read multiple times, if I look at
the memory usage in the control groups, it looks like following


Parent_cgroup : 220MB (rounded)

Child_cgroup_1 : 1MB (rounded)

Child_cgroup_2: 1MB (rounded)


I cleared the disk cache before starting the experiment (using the
command echo 3 > /proc/sys/vm/drop_caches).

My question was : Why is the page cache usage not getting accounted
against Child_cgroup_1 or Child_cgroup_2 ? Is this expected and if
not, is it something I might be doing wrong when configuring cgroups.


My guess is it has something to with the way java provides the
resource access to its threads but I am not sure.

Regards.
AK
