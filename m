From: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Sun, 10 Jul 2022 17:51:22 -0700
Message-ID: <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-9-yosryahmed@google.com>
 <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9L+DcFxkCiQxAE8oBgkRapLUaE/ooS5kS9KF1HfYCFY=;
 b=N0W26MaaAsgJjLIZInxLbcDJgdxzkOWjLVCDoSzkr3cgi1SzlT9qLDqgWrA7wei7D5jR
 s9b64+bKCdNJxY8PfKzAdez7L7qkCuxRQ4M1tEsbLn3hSjUOT7yI3n6sCWYRfCXhPYsi
 l50P5BukipFqY0cHmqMhPYwgZieegClW4JI= 
Content-Language: en-US
In-Reply-To: <b4936952-2fe7-656c-2d0d-69044265392a-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 7/10/22 5:26 PM, Yonghong Song wrote:
> 
> 
> On 7/8/22 5:04 PM, Yosry Ahmed wrote:
>> Add a selftest that tests the whole workflow for collecting,
>> aggregating (flushing), and displaying cgroup hierarchical stats.
>>
>> TL;DR:
>> - Userspace program creates a cgroup hierarchy and induces memcg reclaim
>>    in parts of it.
>> - Whenever reclaim happens, vmscan_start and vmscan_end update
>>    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>>    have updates.
>> - When userspace tries to read the stats, vmscan_dump calls rstat to 
>> flush
>>    the stats, and outputs the stats in text format to userspace (similar
>>    to cgroupfs stats).
>> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>>    updates, vmscan_flush aggregates cpu readings and propagates updates
>>    to parents.
>> - Userspace program makes sure the stats are aggregated and read
>>    correctly.
>>
>> Detailed explanation:
>> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>>    measure the latency of cgroup reclaim. Per-cgroup readings are 
>> stored in
>>    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>>    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>>    rstat updated tree on that cpu.
>>
>> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>>    each cgroup. Reading this file invokes the program, which calls
>>    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates 
>> for all
>>    cpus and cgroups that have updates in this cgroup's subtree. 
>> Afterwards,
>>    the stats are exposed to the user. vmscan_dump returns 1 to terminate
>>    iteration early, so that we only expose stats for one cgroup per read.
>>
>> - An ftrace program, vmscan_flush, is also loaded and attached to
>>    bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is 
>> invoked
>>    once for each (cgroup, cpu) pair that has updates. cgroups are popped
>>    from the rstat tree in a bottom-up fashion, so calls will always be
>>    made for cgroups that have updates before their parents. The program
>>    aggregates percpu readings to a total per-cgroup reading, and also
>>    propagates them to the parent cgroup. After rstat flushing is over, 
>> all
>>    cgroups will have correct updated hierarchical readings (including all
>>    cpus and all their descendants).
>>
>> - Finally, the test creates a cgroup hierarchy and induces memcg reclaim
>>    in parts of it, and makes sure that the stats collection, aggregation,
>>    and reading workflow works as expected.
>>
>> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> ---
>>   .../prog_tests/cgroup_hierarchical_stats.c    | 362 ++++++++++++++++++
>>   .../bpf/progs/cgroup_hierarchical_stats.c     | 235 ++++++++++++
>>   2 files changed, 597 insertions(+)
>>   create mode 100644 
>> tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>>   create mode 100644 
>> tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
>>
> [...]
>> +
>> +static unsigned long long get_cgroup_vmscan_delay(unsigned long long 
>> cgroup_id,
>> +                          const char *file_name)
>> +{
>> +    char buf[128], path[128];
>> +    unsigned long long vmscan = 0, id = 0;
>> +    int err;
>> +
>> +    /* For every cgroup, read the file generated by cgroup_iter */
>> +    snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
>> +    err = read_from_file(path, buf, 128);
>> +    if (!ASSERT_OK(err, "read cgroup_iter"))
>> +        return 0;
>> +
>> +    /* Check the output file formatting */
>> +    ASSERT_EQ(sscanf(buf, "cg_id: %llu, total_vmscan_delay: %llu\n",
>> +             &id, &vmscan), 2, "output format");
>> +
>> +    /* Check that the cgroup_id is displayed correctly */
>> +    ASSERT_EQ(id, cgroup_id, "cgroup_id");
>> +    /* Check that the vmscan reading is non-zero */
>> +    ASSERT_GT(vmscan, 0, "vmscan_reading");
>> +    return vmscan;
>> +}
>> +
>> +static void check_vmscan_stats(void)
>> +{
>> +    int i;
>> +    unsigned long long vmscan_readings[N_CGROUPS], vmscan_root;
>> +
>> +    for (i = 0; i < N_CGROUPS; i++)
>> +        vmscan_readings[i] = get_cgroup_vmscan_delay(cgroups[i].id,
>> +                                 cgroups[i].name);
>> +
>> +    /* Read stats for root too */
>> +    vmscan_root = get_cgroup_vmscan_delay(CG_ROOT_ID, CG_ROOT_NAME);
>> +
>> +    /* Check that child1 == child1_1 + child1_2 */
>> +    ASSERT_EQ(vmscan_readings[1], vmscan_readings[3] + 
>> vmscan_readings[4],
>> +          "child1_vmscan");
>> +    /* Check that child2 == child2_1 + child2_2 */
>> +    ASSERT_EQ(vmscan_readings[2], vmscan_readings[5] + 
>> vmscan_readings[6],
>> +          "child2_vmscan");
>> +    /* Check that test == child1 + child2 */
>> +    ASSERT_EQ(vmscan_readings[0], vmscan_readings[1] + 
>> vmscan_readings[2],
>> +          "test_vmscan");
>> +    /* Check that root >= test */
>> +    ASSERT_GE(vmscan_root, vmscan_readings[1], "root_vmscan");
> 
> I still get a test failure with
> 
> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading: 
> actual 0 <= expected 0
> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual 0 
> != expected -2
> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual 0 
> != expected -2
> check_vmscan_stats:PASS:test_vmscan 0 nsec
> check_vmscan_stats:PASS:root_vmscan 0 nsec
> 
> I added 'dump_stack()' in function try_to_free_mem_cgroup_pages()
> and run this test (#33) and didn't get any stacktrace.
> But I do get stacktraces due to other operations like
>          try_to_free_mem_cgroup_pages+0x1fd [kernel]
>          try_to_free_mem_cgroup_pages+0x1fd [kernel]
>          memory_reclaim_write+0x88 [kernel]
>          cgroup_file_write+0x88 [kernel]
>          kernfs_fop_write_iter+0xd0 [kernel]
>          vfs_write+0x2c4 [kernel]
>          __x64_sys_write+0x60 [kernel]
>          do_syscall_64+0x2d [kernel]
>          entry_SYSCALL_64_after_hwframe+0x44 [kernel]
> 
> If you can show me the stacktrace about how 
> try_to_free_mem_cgroup_pages() is triggered in your setup, I can
> help debug this problem in my environment.

BTW, CI also reported the test failure.
https://github.com/kernel-patches/bpf/pull/3284

For example, with gcc built kernel,
https://github.com/kernel-patches/bpf/runs/7272407890?check_suite_focus=true

The error:

   get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
   get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
   check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: 
actual 28390910 != expected 28390909
   check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: 
actual 0 != expected -2
   check_vmscan_stats:PASS:test_vmscan 0 nsec
   check_vmscan_stats:PASS:root_vmscan 0 nsec

> 
>> +}
>> +
>> +static int setup_cgroup_iter(struct cgroup_hierarchical_stats *obj, 
>> int cgroup_fd,
> [...]
