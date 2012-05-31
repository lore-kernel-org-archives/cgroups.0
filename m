From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
Date: Wed, 30 May 2012 17:44:43 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com>
 <4FC6BC3E.5010807@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=m/+t6U0NiN5VYXi6/J1FXf0rZafbRLdEQYU7NQuckIs=;
        b=BFaCpStc6U4bRLI7TVg5Y3bB8m+HXnIrCdb/3YgL4HR9EBkpIy5FkUkNDMGzqUG+KZ
         ODv777CiyG6t1lCpnCfMzo7ATBy3pWV9oZk5KEznmH/pNkUKrJ9BbwutrOmtPnSqWmt6
         ks9NB8bgtwlPBgbp4HGzuYnzAjwjaayvWS1Uy9DKIMWapGySuBhP2fnVgo2XY/XMVDTs
         p/+RTxc14o5IJGdFtmvFUjWaNHIMQsPNPyEeLfUuYDWDD1hBhnq7tWKlGbLt97cqRbk/
         ZYVPVi+RAAltJBZSqy7ABRVb8XG2sgYXZctJ5ZT9KFPr5gj9MJmbJPR2cX8l2IGaLBKF
         PgIA==
In-Reply-To: <4FC6BC3E.5010807-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Thu, 31 May 2012, Kamezawa Hiroyuki wrote:

> My test with sysfs node's meminfo seems to work...
> 
> [root@rx100-1 qqm]# mount --bind /sys/devices/system/node/node0/meminfo
> /proc/meminfo
> [root@rx100-1 qqm]# cat /proc/meminfo
> 
> Node 0 MemTotal:        8379636 kB

This doesn't seem like a good idea unless the application supports the 
"Node 0" prefix in /proc/meminfo.

If any application really cares about the amount of memory available to 
it, it should be taught to be memcg aware.  Then do something like

cat $(grep memory /proc/mounts | cut -d " " -f 2)/$(grep memory /proc/self/cgroup | cut -d : -f 3)/memory.limit_in_bytes

but since that value can change all the time then it doesn't seem helpful 
unless we have a userspace notifier.
