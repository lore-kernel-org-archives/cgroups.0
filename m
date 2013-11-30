From: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: noprefix mount option
Date: Sat, 30 Nov 2013 12:51:24 +0200
Message-ID: <CAGXs5wVT+MGH6C=DO+iTzbQCFzDmisDiFugBNA8ufaHbvKEoEA@mail.gmail.com>
References: <CAGXs5wVd-fD5xcFJbeN-uSbEKczYuDbBp0BE=vhuM34eBgsqXA@mail.gmail.com>
	<52993619.2090903@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=iQnRF9EuhpLGK4H05t7pw906Fg+wTcYnosAlzVQ1iX8=;
        b=Mq3sXfXdGx00gQgg+ecIWh3qK7s4rQQLj1QjvKUJTEKg7l7qSWBRCRWqCkvqHmWITP
         eyS8h3dAJCrzNnmhwma1NFo/8nwhukViACtuta6PLUw3mkUcb8x8EYuQSBLRUMtFFhQH
         VtZW+v80J+UG9sL5untl/9iCmWDNvTIYAHG0mOvSe1rA8uYzDCh0J1ajJ8nCiaKJ4tuH
         rbjsSVxGcM+S2d5WOcUDzpWomOVurrLO7bE2o0aE5pGbj6U2DMS69b9173gGtk6fr1Jr
         to0dneAIK+2j+po/BgTpbOebHfpE4lbo0tZNi0ledZVrH8QRxEr9sjefPYmtKlYNl+lr
         ec8w==
In-Reply-To: <52993619.2090903-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,
Yes you are right. When I tested it again now on Ubuntu, after reboot,
it was as expected.
Thanks,
Kevin


On Sat, Nov 30, 2013 at 2:49 AM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> On 2013/11/29 22:36, Kevin Wilson wrote:
>> Hello,
>> I hope this is the right place to ask.
>> As far as I know, the noprefix mount option is valid only for cpuset.
>>
>> I ran the following sequence of Fedora 18, 3.6.10-4.fc18.x86_64:
>>
>> mkdir /mytest
>> mount -t tmpfs testcg /mytest
>> mkdir /mytest/testprefix
>> mount -t cgroup -o noprefix,cpuset  testnonprefix /mytest/testprefix/
>>
>> I expected that entries under /mytest/testprefix/ will be without the
>> "cpuset" prefix. However, this is what I get:
>>
>> ls /mytest/testprefix/
>> cgroup.clone_children       cpuset.memory_pressure_enabled
>> cgroup.event_control        cpuset.memory_spread_page
>> cgroup.procs                   cpuset.memory_spread_slab
>> cpuset.cpu_exclusive        cpuset.mems
>> cpuset.cpus                     cpuset.sched_load_balance
>> cpuset.mem_exclusive      cpuset.sched_relax_domain_level
>> cpuset.mem_hardwall       notify_on_release
>> cpuset.memory_migrate    release_agent
>> cpuset.memory_pressure  tasks
>>
>>
>> any ideas ? Am I missing something ?
>>
>
> I've tried this, and it works for me.
>
> My guess is, cpuset had already been mounted:
>
> # mount -t cgroup -o noprefix,cpuset xxx /cgroup
> # ls /cgroup
> cgroup.clone_children  mem_hardwall             mems
> cgroup.event_control   memory_migrate           notify_on_release
> cgroup.procs           memory_pressure          release_agent
> cpu_exclusive          memory_pressure_enabled  sched_load_balance
> cpus                   memory_spread_page       sched_relax_domain_level
> mem_exclusive          memory_spread_slab       tasks
>
> # umount /cgroup
> # mount -t cgroup -o cpuset xxx /cgroup
> # ls /cgroup
> cgroup.clone_children  cpuset.mem_hardwall             cpuset.mems
> cgroup.event_control   cpuset.memory_migrate           cpuset.sched_load_balance
> cgroup.procs           cpuset.memory_pressure          cpuset.sched_relax_domain_level
> cpuset.cpu_exclusive   cpuset.memory_pressure_enabled  notify_on_release
> cpuset.cpus            cpuset.memory_spread_page       release_agent
> cpuset.mem_exclusive   cpuset.memory_spread_slab       tasks
>
> # mount -t cgroup -o noprefix,cpuset xxx /cgroup2/
> # ls /cgroup2/
> cgroup.clone_children  cpuset.mem_hardwall             cpuset.mems
> cgroup.event_control   cpuset.memory_migrate           cpuset.sched_load_balance
> cgroup.procs           cpuset.memory_pressure          cpuset.sched_relax_domain_level
> cpuset.cpu_exclusive   cpuset.memory_pressure_enabled  notify_on_release
> cpuset.cpus            cpuset.memory_spread_page       release_agent
> cpuset.mem_exclusive   cpuset.memory_spread_slab       tasks
>
>
