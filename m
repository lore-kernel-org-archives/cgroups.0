From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Suggestion] kernel: cgroup: mount failure in LTP
 cgroup_regression_test.sh
Date: Wed, 20 Nov 2013 12:35:49 -0500
Message-ID: <20131120173549.GO28946@htj.dyndns.org>
References: <527C9D9B.8090802@asianux.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0sBhOCipykvqOhwNK1CfXrgIjtDazesGV8E9DyoVb0Q=;
        b=kYyt9zxoET/5FZcD5keIQTg8n6SGAzzkA4y4LqqoBZ/kLneNsLp1O/xB4YmLlLdqub
         rch53zXn/amDooK+KQv0PRUmuH4vsX+98Img+qz49dRP1XOUL22BHXZDt2tpKn0RnQQR
         3XH6asriiNf3qXbiAaBYZZEHC82w6hST8HYN8b6jctf8g1S3m84aooPzD+SaHC2FoThr
         /KJNct/z8rzjNvY1yeVz1kuHKSxuYW7lrf9k8y2tuo7uLoZS+54D3GIb4VfUTNPqDlP3
         d/CzW1vyAXs6Pay2lRkgMmORiYN+K9zaMQRH3FMm+HERlZvdXEPJbV8Uo7MQD7lcTO8j
         aCEA==
Content-Disposition: inline
In-Reply-To: <527C9D9B.8090802-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

Sorry about the delay.

On Fri, Nov 08, 2013 at 04:15:23PM +0800, Chen Gang wrote:
> After simplify, the related operation, environments and output are:
> 
>   [root@gchenlinux tmp]# df -Th | grep cgroup
>   tmpfs                             tmpfs    1001M     0 1001M   0% /sys/fs/cgroup
>   [root@gchenlinux tmp]# lsof | grep cgroup | grep -v grep
>   systemd       1          root    6r      DIR               0,18         0       5998 /sys/fs/cgroup/systemd/system
>   [root@gchenlinux tmp]# cat /proc/cgroups 
>   #subsys_name	hierarchy	num_cgroups	enabled
>   cpuset	3	4	1
>   cpu	4	35	1
>   cpuacct	4	35	1
>   freezer	5	4	1
>   [root@gchenlinux tmp]# mkdir cgroup
>   [root@gchenlinux tmp]# mount -t cgroup -o freezer,cpuacct xxx cgroup/
>   mount: xxx already mounted or cgroup/ busy
> 
> Is it real issue of cgroup? If it is, I will/should continue analyzing.

Hmmm... I'm a bit confused.  What is it testing?  "cat /proc/cgroup"
is showing that freezer is already mounted and the kernel seems to
have correctly refused to mount it in a different hierarchy.  What am
I missing here?

Thanks.

-- 
tejun
