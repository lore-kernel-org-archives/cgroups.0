From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: Cannot set memory.memsw.limit_in_bytes for a particular cgroup
Date: Wed, 25 Apr 2012 09:41:26 +0900
Message-ID: <4F974836.1090000@jp.fujitsu.com>
References: <CAE+0DR6yyRHGKYiR-svQAdaV2ZqgaTgPvDMwFFmVs6rJG6w0JA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE+0DR6yyRHGKYiR-svQAdaV2ZqgaTgPvDMwFFmVs6rJG6w0JA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Martin <andrew.s.martin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/04/25 7:47), Andrew Martin wrote:

> Hello,
> 
> 
> I am running a VM with Ubuntu Server 10.04 amd64. I have installed and
> configured cgroups to limit the resources available to samba, nfs, and
> apache. My configuration is as follows:
> /etc/cgconfig.conf
> group nfs {
>         memory {
>                 memory.limit_in_bytes = 500M;
>                 memory.memsw.limit_in_bytes = 1000M;
>         }
>         cpu {
>                 cpu.shares = 10;
>         }
> }
> 
> group smb {
>         memory {
>                 memory.limit_in_bytes = 1500M;
>                 memory.memsw.limit_in_bytes = 2000M;
>         }
>         cpu {
>                 cpu.shares = 13;
>         }
> }
> 
> group apache {
>         memory {
>                 memory.limit_in_bytes = 6G;
>                 memory.memsw.limit_in_bytes = 6G;
>                 memory.swappiness = 5;
>         }
>         cpu {
>                 cpu.shares = 100;
>         }
> }
> 
> 
> mount {
>         cpu = /mnt/cgroups/cpu;
>         cpuacct = /mnt/cgroups/cpuacct;
>         memory = /mnt/cgroups/memory;
>         cpuset = /mnt/cgroups/cpuset;
> }
> 
> /etc/cgrules.conf
> ## Samba Server
> root:/usr/sbin/smbd             cpu,memory      smb/
> root:/usr/sbin/nmbd             cpu,memory      smb/
> 
> ## NFS Server
> root:/usr/sbin/exportfs         cpu,memory      nfs/
> root:/usr/sbin/rpc.mountd       cpu,memory      nfs/
> root:/usr/sbin/rpc.nfsd         cpu,memory      nfs/
> root:/usr/sbin/rpc.svcgssd      cpu,memory      nfs/
> root:nfsd                       cpu,memory      nfs/
> root:nfsd4                      cpu,memory      nfs/
> 
> ## Apache Webserver
> root:apache2                    cpu,memory      apache/
> www-data                        cpu,memory      apache/
> 
> Both memory.limit_in_bytes and memory.memsw.limit_in_bytes seem to
> work fine for the smb cgroup, but no matter what values I use for the
> apache cgroup I cannot set memory.memsw.limit_in_bytes. My goal is to
> disable apache's ability to swap by setting memory.limit_in_bytes and
> memory.memsw.limit_in_bytes to the same value. After running "service
> cgconfig restart" to restart the cgconfig service, I check the value
> of memory.limit_in_bytes and memory.memsw.limit_in_bytes for the
> apache group:
> # cat /mnt/cgroups/memory/apache/memory.limit_in_bytes
> 6442450944
> # cat /mnt/cgroups/memory/apache/memory.memsw.limit_in_bytes
> 9223372036854775807
> 
> The value for memory.memsw.limit_in_bytes is not being initialized. I
> cannot find any related errors in /var/log. I have tried a number of
> different values for memory.memsw.limit_in_bytes, however it will not
> initialize properly. The only error I can see occurs when I restart
> the cgroups service:
> Stopping cgconfig service: rmdir: failed to remove `./smb': Device or
> resource busy
> sed: couldn't flush stdout: No such process
> rmdir: failed to remove `./sysdefault': Device or resource busy
> sed: couldn't flush stdout: No such process
> rmdir: failed to remove `./sysdefault': Device or resource busy
> sed: couldn't flush stdout: Invalid argument
> rmdir: failed to remove `./sysdefault': Device or resource busy
>  *
> Starting cgconfig service:
> 
> What else can I try in order to properly initialize
> memory.memsw.limit_in_bytes? I can temporarily echo a value to it, but
> would prefer a permanent solution.
> 


Then, Does "echo > ...apache/memory.memsw.limit_in_bytes" works fine ?
If so, kernel works fine.

I'm sorry I'm not libcgroup specialist..but..What happens when you write
>         memory {
>                 memory.limit_in_bytes = 6000M;
>                 memory.memsw.limit_in_bytes = 6000M;
>                 memory.swappiness = 5;
>         }

?

Thanks,
-kame
