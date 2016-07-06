From: Noah McNallie <njm-nmK/KmDn8IU@public.gmane.org>
Subject: Re: Pam module seems to have an issue with priority
Date: Wed, 6 Jul 2016 17:43:03 -0400
Message-ID: <8363fcb5-f796-e87f-5d53-1bb7f40b9955@tptp.cc>
References: <491a7616-fae3-269e-cf83-95952b4a325e@tptp.cc>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tptp-cc.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding;
        bh=GUekpsMYuQW3c919DxAt2W39GnQdz3g9a9Mn+4rS3/o=;
        b=AqPgnqaKeJ0bBbgsW416WiIlqG1e8jpTyL3AR5DJRMXhEsfFQHQcrpKrUd5JqyLj+7
         tEVFZfiL2nAF1JxDfmyiPmHpyQXcjRVyRs+EgYAWt8hLBer1+MYaYSg33rSvpufHM48g
         rimm8m68XDCU64op4EO1+xe/kUo4CsE4N20KoP/VLNxIxGEt/WBo9yeLo4VyGvo0zZn3
         aDHGzkZz8OTC4Ys1vQd4ijKe54CANXNFesaH74fW9c5tjZOr9ljSRDFopQuILQ+jYlM6
         4DfYLoTuKibYXv2JPzCcD5xZ0PcvUZ3o+hpNXU6z0PoePd9L3gSHOT6yhbDfHfB8zuow
         BhlQ==
In-Reply-To: <491a7616-fae3-269e-cf83-95952b4a325e-nmK/KmDn8IU@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I find this to be a problem with the /CGFLAG_USECACHE flag which I will 
patch on my machine to test. Correct me if I'm wrong./

/Noah J. McNallie
/

On 7/6/2016 5:26 PM, Noah McNallie wrote:
> Hi, I'm trying to use cgroups for cron and su and ssh login so I added 
> the following in 'system-auth' which they all include gentoo:
>
> session         required        pam_cgroup.so debug
>
> My cgconfig.conf looks as follows:
>
> #
> #  Copyright IBM Corporation. 2007
> #
> #  Authors:     Balbir Singh <balbir-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> #  This program is free software; you can redistribute it and/or 
> modify it
> #  under the terms of version 2.1 of the GNU Lesser General Public 
> License
> #  as published by the Free Software Foundation.
> #
> #  This program is distributed in the hope that it would be useful, but
> #  WITHOUT ANY WARRANTY; without even the implied warranty of
> #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> #
> mount {
>     cpuset  = /sys/fs/cgroup/cpuset;
>     cpu     = /sys/fs/cgroup/cpu;
>     cpuacct = /sys/fs/cgroup/cpuacct;
>     memory  = /sys/fs/cgroup/memory;
> }
>
> group users/alex {
>          perm {
>          task {
>              uid = alex;
>              gid = alex;
>           } admin {
>              uid = root;
>              gid = root;
>           }
>         }
>         cpu {
>                 cpu.shares = 100;
>         }
>         memory {
>                 memory.limit_in_bytes = 134217728;
>         }
> }
>
> -- END --
>
> And my cgrules.conf looks like this:
>
> # /etc/cgrules.conf
> #The format of this file is described in cgrules.conf(5)
> #manual page.
> #
> # Example:
> #<user>         <controllers>   <destination>
> #@student       cpu,memory      usergroup/student/
> #peter          cpu             test1/
> #%              memory          test2/
> # End of file
> alex            cpu,memory      users/alex
>
> -- END --
>
> Now when I su to user alex I see this in /var/log/messages:
>
> Jul  6 17:18:03 atlantic su[5583]: pam_cgroup(su:session): Changed 
> cgroup for process 5583  with username alex.
>
> -- END --
>
> Except that pid is not in users/alex/tasks its in some task files 
> related to openrc and it looks like the function 
> cgroup_change_cgroup_uid_gid_flags is not doing a proper change:
>
> [alex-q63CSc06zXvrDilwLfPoKQ@public.gmane.org][/sys/fs/cgroup]# ls
> blkio  cpu  cpuacct  cpuset  memory  net_cls  openrc
> [alex-q63CSc06zXvrDilwLfPoKQ@public.gmane.org][/sys/fs/cgroup]# find ./ -name tasks | xargs grep 
> 5583
> ./net_cls/tasks:5583
> ./memory/tasks:5583
> ./blkio/tasks:5583
> ./cpuacct/tasks:5583
> ./cpu/openrc_sshd/tasks:5583
> ./cpuset/tasks:5583
> ./openrc/sshd/tasks:5583
> [alex-q63CSc06zXvrDilwLfPoKQ@public.gmane.org][/sys/fs/cgroup]# cat memory/users/alex/tasks
> [alex-q63CSc06zXvrDilwLfPoKQ@public.gmane.org][/sys/fs/cgroup]#
>
> -- END --
>
> Why is it not in users/alex what am I doing wrong?
>
> Noah J. McNallie
>
