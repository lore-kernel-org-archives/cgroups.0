From: Peng Haitao <penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: how to make memory.memsw.failcnt is nonzero
Date: Mon, 30 Jan 2012 10:34:49 +0800
Message-ID: <4F2601C9.6000606@cn.fujitsu.com>
References: <4EFADFF8.5020703@cn.fujitsu.com> <20120103160411.GD3891@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120103160411.GD3891-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


Michal Hocko said the following on 2012-1-4 0:04:
> On Wed 28-12-11 17:23:04, Peng Haitao wrote:
>>
>> memory.memsw.failcnt shows the number of memory+Swap hits limits.
>> So I think when memory+swap usage is equal to limit, memsw.failcnt should be nonzero.
>>
>> I test as follows:
>>
>> # uname -a
>> Linux K-test 3.2.0-rc7-17-g371de6e #2 SMP Wed Dec 28 12:02:52 CST 2011 x86_64 x86_64 x86_64 GNU/Linux
>> # mkdir /cgroup/memory/group
>> # cd /cgroup/memory/group/
>> # echo 10M > memory.limit_in_bytes
>> # echo 10M > memory.memsw.limit_in_bytes
>> # echo $$ > tasks
>> # dd if=/dev/zero of=/tmp/temp_file count=20 bs=1M
>> Killed
>> # cat memory.memsw.failcnt
>> 0
>> # grep "failcnt" /var/log/messages | tail -2
>> Dec 28 17:05:52 K-test kernel: memory: usage 10240kB, limit 10240kB, failcnt 21
>> Dec 28 17:05:52 K-test kernel: memory+swap: usage 10240kB, limit 10240kB, failcnt 0
>>
>> memory+swap usage is equal to limit, but memsw.failcnt is zero.
>>
> Please note that memsw.limit_in_bytes is triggered only if we have
> consumed some swap space already (and the feature is primarily intended
> to stop extensive swap usage in fact).
> It goes like this: If we trigger hard limit (memory.limit_in_bytes) then
> we start the direct reclaim (with swap available). If we trigger memsw
> limit then we try to reclaim without swap available. We will OOM if we
> cannot reclaim enough to satisfy the respective limit.
> 
> The other part of the answer is, yes there is something wrong going
> on her because we definitely shouldn't OOM. The workload is a single
> threaded and we have a plenty of page cache that could be reclaimed
> easily. On the other hand we end up with:
> # echo $$ > tasks 
> /dev/memctl/a# echo 10M > memory.limit_in_bytes 
> /dev/memctl/a# echo 10M > memory.memsw.limit_in_bytes 
> /dev/memctl/a# dd if=/dev/zero of=/tmp/temp_file count=20 bs=1M
> Killed
> /dev/memctl/a# cat memory.stat 
> cache 9265152
> [...]
> 
> So there is almost 10M of page cache that we can simply reclaim. If we
> use 40M limit then we are OK. So this looks like the small limit somehow
> tricks our math in the reclaim path and we think there is nothing to
> reclaim.
> I will look into this.

Have any conclusion for this?
Thanks.

-- 
Best Regards,
Peng
