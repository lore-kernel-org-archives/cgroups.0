From: John Marshall <John.Marshall-5jPdWwX6g8k@public.gmane.org>
Subject: permissions bug?
Date: Fri, 27 Jul 2012 17:01:36 +0000
Message-ID: <5012C970.6050607@ec.gc.ca>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I think there is a permissions bug with cgroups.

In the example below, I am able to create a cgroup directory under /cgroups/jobs
as a non-root user (starting out as root and then calling setgid and setuid, both of
which are effective) without sufficient permissions. Then, if I change the group
write permission to off, I am denied.

Note: when I try mkdir in a regular login shell as myself, the permissions seem to
work correctly as I am denied, whether on not to group write bit is set.

This happens on 2.6.32 (ubuntu 10.04) and 3.2.0 (ubuntu 12.04).

Thanks,
John

root@mel-fe01:/cgroups# ls -ld /cgroups/jobs
drwxrwxr-x 2 root root 0 Jul 27 15:20 /cgroups/jobs
root@mel-fe01:/cgroups# python
Python 2.6.5 (r265:79063, Apr 16 2010, 13:57:41)
[GCC 4.4.3] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import os
>>> os.setgid(108)
>>> os.setuid(859)
>>> os.mkdir("/cgroups/jobs/1")
>>> os.rmdir("/cgroups/jobs/1")
>>>
[1]+  Stopped                 python
root@mel-fe01:/cgroups# chmod g-w /cgroups/jobs
root@mel-fe01:/cgroups# fg
python


>>> os.mkdir("/cgroups/jobs/1")
Traceback (most recent call last):
   File "<stdin>", line 1, in <module>
OSError: [Errno 13] Permission denied: '/cgroups/jobs/1'
>>>
root@mel-fe01:/cgroups# uname -a
Linux mel-fe01 2.6.32-38-server #83-Ubuntu SMP Wed Jan 4 11:26:59 UTC 2012 x86_64 GNU/Linux
