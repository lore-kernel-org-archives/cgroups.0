From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Tue, 19 Jul 2022 09:17:37 -0700
Message-ID: <670999ab-69c8-9692-4d73-da4f96c63e64@fb.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-9-yosryahmed@google.com>
 <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
 <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com>
 <CAJD7tkZUfNqD8z6Cv7vi1TxpwKTXhDn_yweDHnRr++9iJs+=ew@mail.gmail.com>
 <CAJD7tkb8-scb1sstre0LRhY3dgfUJhGvSR=DgEqfwcVtBwb+5w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=yi+Tsyy1Q94v4lg7rzQXwSCA5dLF998Ti/DlLPbUjp4=;
 b=o/tgisskvdt3Eo+W9Qh4HNqdFOf3FudK3U718zBTkMXukwjNQWxSBOEXaLT1IJuQ70il
 RNVmYWc/wKs+Y4poZJ0+TaxeWt4Te/FYfn9VliUpY2hgtuJf43RElszOOI+McwqkT73A
 wD/oUOo43xix6E5vmbyXgXnu7b7G0AsO2o0= 
Content-Language: en-US
In-Reply-To: <CAJD7tkb8-scb1sstre0LRhY3dgfUJhGvSR=DgEqfwcVtBwb+5w@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux



On 7/18/22 12:34 PM, Yosry Ahmed wrote:
> On Mon, Jul 11, 2022 at 8:55 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>>
>> On Sun, Jul 10, 2022 at 5:51 PM Yonghong Song <yhs@fb.com> wrote:
>>>
>>>
>>>
>>> On 7/10/22 5:26 PM, Yonghong Song wrote:
>>>>
>>>>
>>>> On 7/8/22 5:04 PM, Yosry Ahmed wrote:
>>>>> Add a selftest that tests the whole workflow for collecting,
>>>>> aggregating (flushing), and displaying cgroup hierarchical stats.
>>>>>
>>>>> TL;DR:
>>>>> - Userspace program creates a cgroup hierarchy and induces memcg reclaim
>>>>>     in parts of it.
>>>>> - Whenever reclaim happens, vmscan_start and vmscan_end update
>>>>>     per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>>>>>     have updates.
>>>>> - When userspace tries to read the stats, vmscan_dump calls rstat to
>>>>> flush
>>>>>     the stats, and outputs the stats in text format to userspace (similar
>>>>>     to cgroupfs stats).
>>>>> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>>>>>     updates, vmscan_flush aggregates cpu readings and propagates updates
>>>>>     to parents.
>>>>> - Userspace program makes sure the stats are aggregated and read
>>>>>     correctly.
>>>>>
>>>>> Detailed explanation:
>>>>> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>>>>>     measure the latency of cgroup reclaim. Per-cgroup readings are
>>>>> stored in
>>>>>     percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>>>>>     cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>>>>>     rstat updated tree on that cpu.
>>>>>
>>>>> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>>>>>     each cgroup. Reading this file invokes the program, which calls
>>>>>     cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates
>>>>> for all
>>>>>     cpus and cgroups that have updates in this cgroup's subtree.
>>>>> Afterwards,
>>>>>     the stats are exposed to the user. vmscan_dump returns 1 to terminate
>>>>>     iteration early, so that we only expose stats for one cgroup per read.
>>>>>
>>>>> - An ftrace program, vmscan_flush, is also loaded and attached to
>>>>>     bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is
>>>>> invoked
>>>>>     once for each (cgroup, cpu) pair that has updates. cgroups are popped
>>>>>     from the rstat tree in a bottom-up fashion, so calls will always be
>>>>>     made for cgroups that have updates before their parents. The program
>>>>>     aggregates percpu readings to a total per-cgroup reading, and also
>>>>>     propagates them to the parent cgroup. After rstat flushing is over,
>>>>> all
>>>>>     cgroups will have correct updated hierarchical readings (including all
>>>>>     cpus and all their descendants).
>>>>>
>>>>> - Finally, the test creates a cgroup hierarchy and induces memcg reclaim
>>>>>     in parts of it, and makes sure that the stats collection, aggregation,
>>>>>     and reading workflow works as expected.
>>>>>
>>>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>>>> ---
>>>>>    .../prog_tests/cgroup_hierarchical_stats.c    | 362 ++++++++++++++++++
>>>>>    .../bpf/progs/cgroup_hierarchical_stats.c     | 235 ++++++++++++
>>>>>    2 files changed, 597 insertions(+)
>>>>>    create mode 100644
>>>>> tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>>>>>    create mode 100644
>>>>> tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
>>>>>
>>>> [...]
>>>>> +
>>>>> +static unsigned long long get_cgroup_vmscan_delay(unsigned long long
>>>>> cgroup_id,
>>>>> +                          const char *file_name)
>>>>> +{
>>>>> +    char buf[128], path[128];
>>>>> +    unsigned long long vmscan = 0, id = 0;
>>>>> +    int err;
>>>>> +
>>>>> +    /* For every cgroup, read the file generated by cgroup_iter */
>>>>> +    snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
>>>>> +    err = read_from_file(path, buf, 128);
>>>>> +    if (!ASSERT_OK(err, "read cgroup_iter"))
>>>>> +        return 0;
>>>>> +
>>>>> +    /* Check the output file formatting */
>>>>> +    ASSERT_EQ(sscanf(buf, "cg_id: %llu, total_vmscan_delay: %llu\n",
>>>>> +             &id, &vmscan), 2, "output format");
>>>>> +
>>>>> +    /* Check that the cgroup_id is displayed correctly */
>>>>> +    ASSERT_EQ(id, cgroup_id, "cgroup_id");
>>>>> +    /* Check that the vmscan reading is non-zero */
>>>>> +    ASSERT_GT(vmscan, 0, "vmscan_reading");
>>>>> +    return vmscan;
>>>>> +}
>>>>> +
>>>>> +static void check_vmscan_stats(void)
>>>>> +{
>>>>> +    int i;
>>>>> +    unsigned long long vmscan_readings[N_CGROUPS], vmscan_root;
>>>>> +
>>>>> +    for (i = 0; i < N_CGROUPS; i++)
>>>>> +        vmscan_readings[i] = get_cgroup_vmscan_delay(cgroups[i].id,
>>>>> +                                 cgroups[i].name);
>>>>> +
>>>>> +    /* Read stats for root too */
>>>>> +    vmscan_root = get_cgroup_vmscan_delay(CG_ROOT_ID, CG_ROOT_NAME);
>>>>> +
>>>>> +    /* Check that child1 == child1_1 + child1_2 */
>>>>> +    ASSERT_EQ(vmscan_readings[1], vmscan_readings[3] +
>>>>> vmscan_readings[4],
>>>>> +          "child1_vmscan");
>>>>> +    /* Check that child2 == child2_1 + child2_2 */
>>>>> +    ASSERT_EQ(vmscan_readings[2], vmscan_readings[5] +
>>>>> vmscan_readings[6],
>>>>> +          "child2_vmscan");
>>>>> +    /* Check that test == child1 + child2 */
>>>>> +    ASSERT_EQ(vmscan_readings[0], vmscan_readings[1] +
>>>>> vmscan_readings[2],
>>>>> +          "test_vmscan");
>>>>> +    /* Check that root >= test */
>>>>> +    ASSERT_GE(vmscan_root, vmscan_readings[1], "root_vmscan");
>>>>
>>>> I still get a test failure with
>>>>
>>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>>> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
>>>> actual 0 <= expected 0
>>>> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual 0
>>>> != expected -2
>>>> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual 0
>>>> != expected -2
>>>> check_vmscan_stats:PASS:test_vmscan 0 nsec
>>>> check_vmscan_stats:PASS:root_vmscan 0 nsec
>>>>
>>>> I added 'dump_stack()' in function try_to_free_mem_cgroup_pages()
>>>> and run this test (#33) and didn't get any stacktrace.
>>>> But I do get stacktraces due to other operations like
>>>>           try_to_free_mem_cgroup_pages+0x1fd [kernel]
>>>>           try_to_free_mem_cgroup_pages+0x1fd [kernel]
>>>>           memory_reclaim_write+0x88 [kernel]
>>>>           cgroup_file_write+0x88 [kernel]
>>>>           kernfs_fop_write_iter+0xd0 [kernel]
>>>>           vfs_write+0x2c4 [kernel]
>>>>           __x64_sys_write+0x60 [kernel]
>>>>           do_syscall_64+0x2d [kernel]
>>>>           entry_SYSCALL_64_after_hwframe+0x44 [kernel]
>>>>
>>>> If you can show me the stacktrace about how
>>>> try_to_free_mem_cgroup_pages() is triggered in your setup, I can
>>>> help debug this problem in my environment.
>>>
>>> BTW, CI also reported the test failure.
>>> https://github.com/kernel-patches/bpf/pull/3284
>>>
>>> For example, with gcc built kernel,
>>> https://github.com/kernel-patches/bpf/runs/7272407890?check_suite_focus=true
>>>
>>> The error:
>>>
>>>     get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>>     get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
>>>     check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan:
>>> actual 28390910 != expected 28390909
>>>     check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan:
>>> actual 0 != expected -2
>>>     check_vmscan_stats:PASS:test_vmscan 0 nsec
>>>     check_vmscan_stats:PASS:root_vmscan 0 nsec
>>>
>>
>> Hey Yonghong,
>>
>> Thanks for helping us debug this failure. I can reproduce the CI
>> failure in my enviornment, but this failure is actually different from
>> the failure in your environment. In your environment it looks like no
>> stats are gathered for all cgroups (either no reclaim happening or bpf
>> progs not being run). In the CI and in my environment, only one cgroup
>> observes this behavior.
>>
>> The thing is, I was able to reproduce the problem only when I ran all
>> test_progs. When I run the selftest alone (test_progs -t
>> cgroup_hierarchical_stats), it consistently passes, which is
>> interesting.
> 
> I think I figured this one out (the CI failure). I set max_entries for
> the maps in the test to 10, because I have 1 entry per-cgroup, and I
> have less than 10 cgroups. When I run the test with other tests I
> *think* there are other cgroups that are being created, so the number
> exceeds 10, and some of the entries for the test cgroups cannot be
> created. I saw a lot of "failed to create entry for cgroup.." message
> in the bpf trace produced by my test, and the error turned out to be
> -E2BIG. I increased max_entries to 100 and it seems to be consistently
> passing when run with all the other tests, using both test_progs and
> test_progs-no_alu32.
> 
> Please find a diff attached fixing this problem and a few other nits:
> - Return meaningful exit codes from the reclaimer() child process and
> check them in induce_vmscan().
> - Make buf and path variables static in get_cgroup_vmscan_delay()
> - Print error code in bpf trace when we fail to create a bpf map entry.
> - Print 0 instead of -1 when we can't find a map entry, to avoid
> underflowing the unsigned counters in the test.
> 
> Let me know if this diff works or not, and if I need to send a new
> version with the diff or not. Also let me know if this fixes the
> failures that you have been seeing locally (which looked different
> from the CI failures).

I tried this patch and the test passed in my local environment
so the diff sounds good to me.

> 
> Thanks!
> 
>>
>> Anyway, one failure at a time :) I am working on debugging the CI
>> failure (that occurs only when all tests are run), then we'll see if
>> fixing that fixes the problem in our environment as well.
>>
>> If you have any pointers about why a test would consistently pass
>> alone and consistently fail with others that would be good. Otherwise,
>> I will keep you updated with any findings I reach.
>>
>> Thanks again!
>>
>>>>
>>>>> +}
>>>>> +
>>>>> +static int setup_cgroup_iter(struct cgroup_hierarchical_stats *obj,
>>>>> int cgroup_fd,
>>>> [...]
