From: Andrew Martin <andrew.s.martin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cannot set memory.memsw.limit_in_bytes for a particular cgroup
Date: Tue, 24 Apr 2012 20:00:08 -0500
Message-ID: <D5FAE552-76FE-43DB-B803-FD6F595C1518@gmail.com>
References: <CAE+0DR6yyRHGKYiR-svQAdaV2ZqgaTgPvDMwFFmVs6rJG6w0JA@mail.gmail.com> <4F974836.1090000@jp.fujitsu.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=references:in-reply-to:mime-version:content-transfer-encoding
         :content-type:message-id:cc:x-mailer:from:subject:date:to;
        bh=1awwp/WlctPhwHLVK7L+jxewXkTQTmbKRXvenxblrdE=;
        b=JDy1ijz2ZTbmZ5EB0636F+sH/tho22OglnAAFqCpiJXgltrRKBsM0jB4P/xL7PzkD4
         3RhVS+fTHto2g4gu2R+5VkTRboIt4f1Vwhk+AnAiFHeigr6YVJ506BOrfkSHCSJmzrYM
         s+F1DiUDN2HUQti/aso8LLmY9wGbY8zRrCG2dAydWxICnNghknEw7c3A0z62Z5zLDzff
         8TVmn7qCsq4ElOaVrgtHcYMnWzz9zNGMatwO+Tr7nruUMokgt6ctB6d5Q1QYyhRewZ0i
         2kTV+gkf+RDWpIZC+D09xWzcAZTtE/uKRpCiwGv7tyIsHsd3i3Malwl1r1SpxQCyg+eX
         VkKg==
In-Reply-To: <4F974836.1090000-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Kame,

On Apr 24, 2012, at 7:41 PM, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:

> (2012/04/25 7:47), Andrew Martin wrote:
> 
>> Hello,
>> 
>> 
>> I am running a VM with Ubuntu Server 10.04 amd64. I have installed and
>> configured cgroups to limit the resources available to samba, nfs, and
>> apache. My configuration is as follows:
>> /etc/cgconfig.conf
>> group nfs {
>>        memory {
>>                memory.limit_in_bytes = 500M;
>>                memory.memsw.limit_in_bytes = 1000M;
>>        }
>>        cpu {
>>                cpu.shares = 10;
>>        }
>> }
>> 
>> group smb {
>>        memory {
>>                memory.limit_in_bytes = 1500M;
>>                memory.memsw.limit_in_bytes = 2000M;
>>        }
>>        cpu {
>>                cpu.shares = 13;
>>        }
>> }
>> 
>> group apache {
>>        memory {
>>                memory.limit_in_bytes = 6G;
>>                memory.memsw.limit_in_bytes = 6G;
>>                memory.swappiness = 5;
>>        }
>>        cpu {
>>                cpu.shares = 100;
>>        }
>> }
>> 
>> 
>> mount {
>>        cpu = /mnt/cgroups/cpu;
>>        cpuacct = /mnt/cgroups/cpuacct;
>>        memory = /mnt/cgroups/memory;
>>        cpuset = /mnt/cgroups/cpuset;
>> }
>> 
>> /etc/cgrules.conf
>> ## Samba Server
>> root:/usr/sbin/smbd             cpu,memory      smb/
>> root:/usr/sbin/nmbd             cpu,memory      smb/
>> 
>> ## NFS Server
>> root:/usr/sbin/exportfs         cpu,memory      nfs/
>> root:/usr/sbin/rpc.mountd       cpu,memory      nfs/
>> root:/usr/sbin/rpc.nfsd         cpu,memory      nfs/
>> root:/usr/sbin/rpc.svcgssd      cpu,memory      nfs/
>> root:nfsd                       cpu,memory      nfs/
>> root:nfsd4                      cpu,memory      nfs/
>> 
>> ## Apache Webserver
>> root:apache2                    cpu,memory      apache/
>> www-data                        cpu,memory      apache/
>> 
>> Both memory.limit_in_bytes and memory.memsw.limit_in_bytes seem to
>> work fine for the smb cgroup, but no matter what values I use for the
>> apache cgroup I cannot set memory.memsw.limit_in_bytes. My goal is to
>> disable apache's ability to swap by setting memory.limit_in_bytes and
>> memory.memsw.limit_in_bytes to the same value. After running "service
>> cgconfig restart" to restart the cgconfig service, I check the value
>> of memory.limit_in_bytes and memory.memsw.limit_in_bytes for the
>> apache group:
>> # cat /mnt/cgroups/memory/apache/memory.limit_in_bytes
>> 6442450944
>> # cat /mnt/cgroups/memory/apache/memory.memsw.limit_in_bytes
>> 9223372036854775807
>> 
>> The value for memory.memsw.limit_in_bytes is not being initialized. I
>> cannot find any related errors in /var/log. I have tried a number of
>> different values for memory.memsw.limit_in_bytes, however it will not
>> initialize properly. The only error I can see occurs when I restart
>> the cgroups service:
>> Stopping cgconfig service: rmdir: failed to remove `./smb': Device or
>> resource busy
>> sed: couldn't flush stdout: No such process
>> rmdir: failed to remove `./sysdefault': Device or resource busy
>> sed: couldn't flush stdout: No such process
>> rmdir: failed to remove `./sysdefault': Device or resource busy
>> sed: couldn't flush stdout: Invalid argument
>> rmdir: failed to remove `./sysdefault': Device or resource busy
>> *
>> Starting cgconfig service:
>> 
>> What else can I try in order to properly initialize
>> memory.memsw.limit_in_bytes? I can temporarily echo a value to it, but
>> would prefer a permanent solution.
>> 
> 
> 
> Then, Does "echo > ...apache/memory.memsw.limit_in_bytes" works fine ?
> If so, kernel works fine.
> 
It appears to work, in that if I cat it after doing so the new value is retained. However, I have not pushed apache hard enough after doing it to see if the limit is really enforced, though I agree it looks like it is being set correctly using this method.

> I'm sorry I'm not libcgroup specialist..but..What happens when you write
>>        memory {
>>                memory.limit_in_bytes = 6000M;
>>                memory.memsw.limit_in_bytes = 6000M;
>>                memory.swappiness = 5;
>>        }
> 
I also tried that as well as specifying the bytes directly, with no improvement. I also tried different values for memory.memsw.limit_in_bytes from 6000 to 6256 in both powers of 2 and 10.

Any other ideas?

Thanks!!!

Andrew

> ?
> 
> Thanks,
> -kame
> 
