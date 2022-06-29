From: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Tue, 28 Jun 2022 23:17:16 -0700
Message-ID: <5a28a1c7-0420-ca93-0b92-fd54e726ed8c@fb.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-9-yosryahmed@google.com>
 <00df1932-38fe-c6f8-49d0-3a44affb1268@fb.com>
 <CAJD7tkaNnx6ebFrMxWgkJbtx=Qoe+cEwnjtWeY5=EAaVktrenw@mail.gmail.com>
 <CAJD7tkZ3AEPEUD9V-5nxUgmS5SLc6qp50ZyrRoAQgdzPM=a-Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ooy3Gc5a2eb+IgnWx6/fKAomiRpDs+e4kGIE6Z8bdDw=;
 b=oK2f9j4QxapxxrAyy/2x+l+PUgUlvw4nlLqT0jhx6DSXNk43eNC9ch8GOIO9RTe+J/qo
 JWVXdEeEXJECFbEYPwTCzDCzj1uUCDHW+tcqMqt0JMgKKIBKKTiHVStWnmm1Fv61CTBU
 Qozr4BEo2Djbt8wwmmSLdQcLxAPD9b3ZClI= 
Content-Language: en-US
In-Reply-To: <CAJD7tkZ3AEPEUD9V-5nxUgmS5SLc6qp50ZyrRoAQgdzPM=a-Hg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



On 6/28/22 12:14 AM, Yosry Ahmed wrote:
> On Mon, Jun 27, 2022 at 11:47 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On Mon, Jun 27, 2022 at 11:14 PM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
>>>
>>>
>>>
>>> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
>>>> Add a selftest that tests the whole workflow for collecting,
>>>> aggregating (flushing), and displaying cgroup hierarchical stats.
>>>>
>>>> TL;DR:
>>>> - Whenever reclaim happens, vmscan_start and vmscan_end update
>>>>     per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>>>>     have updates.
>>>> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
>>>>     the stats, and outputs the stats in text format to userspace (similar
>>>>     to cgroupfs stats).
>>>> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>>>>     updates, vmscan_flush aggregates cpu readings and propagates updates
>>>>     to parents.
>>>>
>>>> Detailed explanation:
>>>> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>>>>     measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
>>>>     percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>>>>     cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>>>>     rstat updated tree on that cpu.
>>>>
>>>> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>>>>     each cgroup. Reading this file invokes the program, which calls
>>>>     cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
>>>>     cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
>>>>     the stats are exposed to the user. vmscan_dump returns 1 to terminate
>>>>     iteration early, so that we only expose stats for one cgroup per read.
>>>>
>>>> - An ftrace program, vmscan_flush, is also loaded and attached to
>>>>     bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
>>>>     once for each (cgroup, cpu) pair that has updates. cgroups are popped
>>>>     from the rstat tree in a bottom-up fashion, so calls will always be
>>>>     made for cgroups that have updates before their parents. The program
>>>>     aggregates percpu readings to a total per-cgroup reading, and also
>>>>     propagates them to the parent cgroup. After rstat flushing is over, all
>>>>     cgroups will have correct updated hierarchical readings (including all
>>>>     cpus and all their descendants).
>>>>
>>>> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>
>>> There are a selftest failure with test:
>>>
>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>> get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
>>> get_cgroup_vmscan_delay:PASS:read cgroup_iter 0 nsec
>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
>>> actual 0 <= expected 0
>>> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual
>>> 781874 != expected 382092
>>> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual
>>> -1 != expected -2
>>> check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual
>>> 781874 != expected 781873
>>> check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 <
>>> expected 781874
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter root pin 0 nsec
>>> cleanup_bpffs:PASS:rmdir /sys/fs/bpf/vmscan/ 0 nsec
>>> #33      cgroup_hierarchical_stats:FAIL
>>>
>>
>> The test is passing on my setup. I am trying to figure out if there is
>> something outside the setup done by the test that can cause the test
>> to fail.
>>
> 
> I can't reproduce the failure on my machine. It seems like for some
> reason reclaim is not invoked in one of the test cgroups which results
> in the expected stats not being there. I have a few suspicions as to
> what might cause this but I am not sure.
> 
> If you have the capacity, do you mind re-running the test with the
> attached diff1.patch? (and maybe diff2.patch if that fails, this will
> cause OOMs in the test cgroup, you might see some process killed
> warnings).

The patch doesn't help. Still failed.

get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading: 
actual 0 <= expected 0
check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual 
676612 != expected 339142
check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual 
-1 != expected -2
check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual 
676612 != expected 676611
check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 < 
expected 676612
destroy_progs:PASS:remove cgroup_iter pin 0 nsec
destroy_progs:PASS:remove cgroup_iter pin 0 nsec


> Thanks!
> 
> 
>>>
>>> Also an existing test also failed.
[...]
