From: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Tue, 28 Jun 2022 23:26:51 -0700
Message-ID: <59376285-21bc-ff12-3d64-3ea7257becb2@fb.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-9-yosryahmed@google.com>
 <00df1932-38fe-c6f8-49d0-3a44affb1268@fb.com>
 <CAJD7tkaNnx6ebFrMxWgkJbtx=Qoe+cEwnjtWeY5=EAaVktrenw@mail.gmail.com>
 <CAJD7tkbOztCEWgMzoCOdD+g3whMMQWW2e0gwo9p0tVK=3hqmcw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=A/sEaSIpioHKs2Bbfr4HKimR0DcmMDLF9iK8j7qY+eY=;
 b=Ww9LpyYmmYKTi3My2zLD3ESJKjaAoFOU+865EhcOpMfUMhvJ9TqikzC+9esTiFbjyjg+
 3AKzhzja8+V0SoSek+6/4TBRbYvb5y1re2wbSVFgWbqLDn0K7Vdk+JG9h5uR8+w1LW6d
 2pgyLQ9DBakkNts+kLe3HfIUaDQ02WBAsXo= 
Content-Language: en-US
In-Reply-To: <CAJD7tkbOztCEWgMzoCOdD+g3whMMQWW2e0gwo9p0tVK=3hqmcw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



On 6/28/22 12:43 AM, Yosry Ahmed wrote:
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
>>>
>>> Also an existing test also failed.
>>>
>>> btf_dump_data:PASS:find type id 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:failed/unexpected type_sz 0 nsec
>>>
>>>
>>> btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
>>> expected/actual match: actual '(union bpf_iter_link_info){.map =
>>> (struct){.map_fd = (__u32)1,},.cgroup '
>>> test_btf_dump_struct_data:PASS:find struct sk_buff 0 nsec
>>>
>>
>> Yeah I see what happened there. bpf_iter_link_info was changed by the
>> patch that introduced cgroup_iter, and this specific union is used by
>> the test to test the "union with nested struct" btf dumping. I will
>> add a patch in the next version that updates the btf_dump_data test
>> accordingly. Thanks.
>>
> 
> So I actually tried the attached diff to updated the expected dump of
> bpf_iter_link_info in this test, but the test still failed:
> 
> btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
> expected/actual match: actual '(union bpf_iter_link_info){.map =
> (struct){.map_fd = (__u32)1,},.cgroup = (struct){.cgroup_fd =
> (__u32)1,},}'  != expected '(union bpf_iter_link_info){.map =
> (struct){.map_fd = (__u32)1,},.cgroup = (struct){.cgroup_fd =
> (__u32)1,.traversal_order = (__u32)1},}'
> 
> It seems to me that the actual output in this case is not right, it is
> missing traversal_order. Did we accidentally find a bug in btf dumping
> of unions with nested structs, or am I missing something here?

Probably there is an issue in btf_dump_data() function in
tools/lib/bpf/btf_dump.c. Could you take a look at it?

> Thanks!
> 
>>>
>>> test_btf_dump_struct_data:PASS:unexpected return value dumping sk_buff 0
>>> nsec
>>>
>>> btf_dump_data:PASS:verify prefix match 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:find type id 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:verify prefix match 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:find type id 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
>>>
>>>
>>> #21/14   btf_dump/btf_dump: struct_data:FAIL
>>>
>>> please take a look.
>>>
>>>> ---
>>>>    .../prog_tests/cgroup_hierarchical_stats.c    | 351 ++++++++++++++++++
>>>>    .../bpf/progs/cgroup_hierarchical_stats.c     | 234 ++++++++++++
>>>>    2 files changed, 585 insertions(+)
>>>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>>>>    create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
>>>>
[...]
