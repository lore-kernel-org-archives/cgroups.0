Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEEF3115BC
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 05:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786425382; cv=none; b=D3WpPRUwZqjHz92LnO4EJJw5k7HECJAIhDjkk2E45aP8mLbhURLrNJI4UdwrjnHvcreLTeQf0WjuFRqpxvLU2ZJh+g6a0CcpQXhOOZvesjwiNm9l4qM7ymVWSp+FyRyoCoWZXM/AR4N9nvbCJ5jzt4YcSE3qyF9xh5iR6BLL574=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786425382; c=relaxed/simple;
	bh=rq7Jo7vNhFyWoaNsGX0c1Ifh3WxEEF9ECeI2CR7jGsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bZneuEgpyay9jsMhswOnC4s6IZ0YCAPpYa9pkhYJWYfZWlH5XVenhGJMbbnGK+p8XhjBTz+YsbVL9ROL8/6pNCnGm3gMbNb5ja5mEocVnE2/sXjp7wwxSAXM1sGi01e1UOc4KXeRngJBklcBIR3w29XV+1xofP4HdYO8SBvC7qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gFSt92Km; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=X8XfqAlN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gFSt92Km";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="X8XfqAlN"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AMq0Ke3047857
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 05:16:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Z22u4Y6qlTT7YZHZuEf9UIZJTy0sb+lujCBIrKH+O7E=; b=gFSt92Km6Te2K31E
	lwlexjI58oi6BIF8WTfEF8LYpWSOt5Qj+1mM4OMgeTtMHPByJ53fV5yk32g8e84A
	rbkAbah+k0XMZwiXhgKqMzQ+DaLdLZalQ4p8GxJGJ3VRhkiwLZoYIAsT+diOoxlN
	+9wYaZFsUBqs6teiQKMghj4gv7FsrE7jCzI8CbdL7qU3QA1vqbOu8rIdQ+zMD5zr
	LPwTTpUl3MUMQij0xpj2MDpJkXTsOhrYofZa0nzpRlCTx9AOG3OheTRauguT/SZ1
	xG9Vj51TivUw6MWhIRo3QrTad7mJJdi+lG90rpQiZdREGplTzwrGsucZbpkZvZkC
	7kFYOw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fyjk22g9s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 05:16:20 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce7dfd33ffso6018415ad.0
        for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 22:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786425380; x=1787030180; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z22u4Y6qlTT7YZHZuEf9UIZJTy0sb+lujCBIrKH+O7E=;
        b=X8XfqAlNLOkBFT0v+S7++Ag/LVma9p5UNGM/1tWw7T7j+do4Ci7GNQAI3NtOUlXzDP
         WyEiQCnym1Vsb2husllv72RElnXvU+mwEXMSqidcGR6x+/x1ZLZCRYE82J6vghlWOX+k
         JiXQ4ku067pD7yuow1RT/yUL1Q2LT/IArTBr5mq1Z6tQxeasviNpmY6sZ6Vz4z4mrH2E
         FAYYxHRMPF3Jsq4vhpKjFQMyWoP8zxCRgvBt0WbhSr+TVkfblDGTKVrK3IFrRxkYy2MC
         i8taqW1v0v9rvBWsAlBxMOB9lmoj+aA292wyNG5lLU0/7O4/8i7JNXeidKvw7nlM2WsL
         zrSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786425380; x=1787030180;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z22u4Y6qlTT7YZHZuEf9UIZJTy0sb+lujCBIrKH+O7E=;
        b=bB9odPpwEDw5miIkyV8EDP6/gk5+IO/4Igg6Iwm8UunGTMRO+zVA5x7NyRrlCNyr0d
         h++kltCMIx2gijmHVXuKtYJe87i+q31zZNeP/M5i/Qqe7D4a+KlcFSCLf3+e+aPFn3GZ
         5kA/ffAjCpWmQLG7H9uhxRXTwu+lwUWF0qL4QU8vMbJh9jqLfkY+SssIpRBin5P5UhaR
         lfNCSjeUuaKtJpGnVMoAL3KlpRnjeE4mP9WZ2QQwyeBYgJ3CjK006Pxnl9JwICc7jE1q
         +axqhBybqJDKqphb75HdlDHvQ/AiL5qh9KMG4zS3aJiRjnmGM6RFKSJlPC6xA2S8uBfq
         5Zww==
X-Forwarded-Encrypted: i=1; AHgh+RqJ/ZKUEh9NZi9vgg0BjR5zHabJWYLzc6OD431BrEGJRDDpB2blYOmPaJJgI6W9QDU0QGjRcLEH@vger.kernel.org
X-Gm-Message-State: AOJu0YxCwUXZpPZ1LIekXlO7Fi4qesCKPLFjkFhTRduDedefLpTi3aKn
	ypKyaktypeQOwuwSY6dO45vBMqGp5vsJ3ZQq7f27MAN8fk6VSDkOVB/nOnLeUj5lFulCkJhYUGq
	tme7nDPP+hcD4EgUgQRD6QwMXn/yXt+a/ip++/WfWsz7C8yp7aSvjqD2rRt2Z
X-Gm-Gg: AR+sD11qBPASb5MedU+1Ro+ODQg76YLoLrcAIXilbLcnGbetS2RvSh/0LTcbLNmD508
	oE/kDVRklBwhTeNgWKhINlsGYt5LDWWgVYk7SkFeFVDLloBFAChiMVz0KmYIlP8H5v/ITiplbXF
	MJZiq/GHL+4tvjduA0zKd3yQiilkCGx/KNCJ8ovqg8mlWhhqa0+SS0mKSUNT8E0wkomYUrymKOD
	oUZ2D0CIqwu160sAlTarXdk04D48poUhqj+vuDtyFbq+//CivjcpteHNe13CMNoT/SG4R9cX4bD
	fUeVsC7+7XyU64s/hHWF2s6UgL25OhrIpJ3j36brOT98ln5WSwzeGOnBxvKcEP5mW6VkRbxfEn+
	xW8vJAMKk5Kr7l+EMAFVWgMRPGZhyYm8U
X-Received: by 2002:a17:903:3c4f:b0:2b7:975c:dacc with SMTP id d9443c01a7336-2d3177d6f58mr11611875ad.1.1786425379963;
        Mon, 10 Aug 2026 22:16:19 -0700 (PDT)
X-Received: by 2002:a17:903:3c4f:b0:2b7:975c:dacc with SMTP id d9443c01a7336-2d3177d6f58mr11611395ad.1.1786425379454;
        Mon, 10 Aug 2026 22:16:19 -0700 (PDT)
Received: from [192.168.1.3] ([122.177.240.172])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d31623091dsm1505835ad.77.2026.08.10.22.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 22:16:18 -0700 (PDT)
Message-ID: <53e05300-b84c-4a04-a7b4-5022285bcbdc@oss.qualcomm.com>
Date: Tue, 11 Aug 2026 10:46:14 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memcg: fix NULL nodeinfo[] dereference on late-onlined
 nodes
To: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-arm-msm@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20260810-memcg-nodeinfo-null-guard-v1-1-77a73204d63a@oss.qualcomm.com>
 <5059A780-9C10-4171-A254-38944464F1AC@linux.dev>
Content-Language: en-US
From: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
In-Reply-To: <5059A780-9C10-4171-A254-38944464F1AC@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA0MSBTYWx0ZWRfX1L7vnoApw2Zb
 JPeAZ4Bl7SK6WOrGSlJPKvk1jNm96YjLbZc49mNWdERwKEABIHb/dit1U8J+apEyY7WK48pywD4
 4lor700MXlA6YqJDc5uuuG6SlurhTSw=
X-Proofpoint-GUID: 7F-F_ZKbTi6JpqiOUHKF62yvD35jbrJC
X-Proofpoint-ORIG-GUID: 7F-F_ZKbTi6JpqiOUHKF62yvD35jbrJC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA0MSBTYWx0ZWRfXzwEH6ckgIBRI
 ReQHS7RQxb+MKY9pgrc7r5GAgc8GoBsMwgjyLP4kLbx7puvxzPY1t6bBAeTHugTyzQ9V4gh7gyf
 oqXFaMm1rNO+NtKIPnzokGB95YPm1uZLf8q0/XsZwqeJokoZcyoiOzdLUNVRXmkzoi/6+tzAWxy
 zbXE+CBhf4DaQrE2BiPnAFKX37gZDsQ+rGWaEriK0t6gP3qOIZ7bOfD9XABu1kxkw16qW751s8w
 JY2h0r4YKbwVjM0cELkys2IrZle8HRQUtO4kKmMPT2DxXSVikWXD0wWQHkUo8lBEHAa1x/FR5Nx
 jKjnLNth18itp8oj/sstJKktAHiNLFCZQKAq6QwvrdF3PxvLpvmpcqPJiGaIhy5InMm+m1SCcjF
 GKXRUpMaRD6cmuZbLbpH49oIurte7+g5cM6TENUXF9xg1xMIB4pS9aRVHr68Loqi7wVSdnbv+9Z
 NNhd8PX/gmjv12YPWkw==
X-Authority-Analysis: v=2.4 cv=eJ4jSnp1 c=1 sm=1 tr=0 ts=6a7ab024 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=/KRT0UA7ihr0Zk0c0WlnJw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=CXD26xkfXwuzw2POT1oA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608110041



On 8/10/2026 1:28 PM, Muchun Song wrote:
> 
> 
>> On Aug 10, 2026, at 13:46, Prakash Gupta <prakash.gupta@oss.qualcomm.com> wrote:
>>
>> memcg->nodeinfo[] entries are allocated only for nodes present at
>> css_alloc time. When a node is onlined after a memcg is created its
>> nodeinfo[] slot remains NULL. Two call sites dereference these slots
>> unconditionally:
> 
> I don't think the premise of this patch is correct.
> 
> memcg->nodeinfo[] is not allocated only for nodes that are present or
> online at css_alloc time. mem_cgroup_alloc() allocates per-node info with
> for_each_node(), and for_each_node() iterates N_POSSIBLE nodes:
> 
>         for_each_node(node)
>                 alloc_mem_cgroup_per_node_info(memcg, node);
> 

You are right. I rechecked and nodeinfo[] is allocated for all possible
nodes at mem_cgroup_alloc() time, not just currently online ones.

> If memcg->nodeinfo[nid] is NULL on your system, that looks like a
> violation of this invariant, or possibly a downstream-specific change,
> bad nid, allocation/lifetime issue, or memory corruption. I don't think
> the generic explanation that "the node was onlined after the memcg was
> created" is sufficient.
> 
Agreed. I will investigate further before resubmitting that part.

>>
>> lruvec_stat_mod_folio() calls mem_cgroup_lruvec() which reads
>> memcg->nodeinfo[pgdat->node_id] without a NULL check. On a system
>> where a node is onlined after the memcg is created, any folio stat
>> update for that node crashes with a NULL pointer dereference:
>>
>>  Unable to handle kernel paging request at virtual address ffffffbebf7e1908
>>  pc : lruvec_stat_mod_folio+0xf0/0x444   [6.18.21-android17-5]
>>  lr : lruvec_stat_mod_folio+0x88/0x444
>>  Call trace:
>>   lruvec_stat_mod_folio+0xf0/0x444
>>   folio_add_new_anon_rmap+0xac/0x2b8
>>   do_wp_page+0x768/0xc80
>>   handle_mm_fault+0x37c/0x8c4
>>   do_page_fault+0x140/0xa1c
>>   do_mem_abort+0x54/0x74
>>   el0_da+0x48/0x8c
>>   el0t_64_sync_handler+0x20/0x130
>>   el0t_64_sync+0x1c4/0x1c8
>>
>> __invalidate_reclaim_iterators() iterates for_each_node() and reads
>> from->nodeinfo[nid]->iter without checking for NULL. for_each_node()
>> visits all possible nodes, so this is reachable whenever a node is
>> onlined after the memcg was created.
>>
>> Fix lruvec_stat_mod_folio() by checking nodeinfo[pgdat->node_id]
>> directly and falling back to mod_node_page_state() when NULL, mirroring
>> the existing !memcg early-return path. The fallback must not go through
>> mod_lruvec_state() since that calls mod_memcg_lruvec_state() which uses
>> container_of() to recover the mem_cgroup_per_node from the lruvec
>> pointer; passing &pgdat->__lruvec there produces a garbage pointer.
>> When nodeinfo[nid] is NULL the memcg has no per-node accounting
>> structure for that node, so node-level accounting is correct.
>>
>> Fix __invalidate_reclaim_iterators() by skipping NULL nodeinfo[] slots.
>>
>> Also switch lruvec_stat_mod_folio() to folio_memcg_check() which uses
>> READ_ONCE() to safely read folio->memcg_data in an unlocked context.
>>
>> Fixes: 6c77b607ee26 ("mm: kill lock|unlock_page_memcg()")
> 
> The Fixes tag also seems odd. 6c77b607ee26 ("mm: kill
> lock|unlock_page_memcg()") only removed/renamed the lock_page_memcg()
> wrappers and does not appear to change nodeinfo[] allocation or memory
> hotplug handling. Could you explain how that commit introduced the NULL
> nodeinfo condition?
> 

It did not. It seems I picked up the commit based on git blame on
function as there were two related bugs reports that I was conflating
into one patch as listed below, will fix that in v2.

Variant A (missed to mentioned in commit msg) — NULL dereference:

    Unable to handle kernel NULL pointer dereference
      at virtual address 0000000000000528
    ESR = 0x0000000096000005 (read fault)
    Workqueue: events delayed_fput
    pc : lruvec_stat_mod_folio+0x5c/0x444  [6.18.21-android17-5]
    lr : lruvec_stat_mod_folio+0x2c/0x444

As you suggested this may need more investigation.

Variant B (the crash included in the patch) — stale pointer:

    Unable to handle kernel paging request
      at virtual address ffffffbebf7e1908
    ESR = 0x0000000096000045 (write fault)
    pc : __lruvec_stat_mod_folio+0xf0/0x444  [6.18.21-android17-5]
    lr : __lruvec_stat_mod_folio+0x88/0x444
    Call trace:
      __lruvec_stat_mod_folio+0xf0/0x444
      folio_add_new_anon_rmap+0xac/0x2b8
      do_wp_page+0x768/0xc80
      handle_mm_fault+0x37c/0x8c4
      do_page_fault+0x140/0xa1c

__lruvec_stat_mod_folio+0xf0 places it after the !memcg NULL check.This
is consistent with folio_memcg() returning a stale memcg pointer that
passes the NULL check.

folio_memcg_check() uses READ_ONCE(folio->memcg_data) which seems the
correct API for unlocked contexts. folio_memcg_check() has been
available since becacb04fdd4 ("mm: memcg: add folio_memcg_check()")
but lruvec_stat_mod_folio() was never updated to use it.

I should also note that this crash is difficult to reproduce in a
controlled environment — the analysis is based on crashdump inspection.
I have not been able to construct a reliable reproducer so far.

let me know your thoughts on this, accordingly I can send a v2 to cover
only Variant B fix as explained above.

>> Cc: stable@vger.kernel.org
>> Assisted-by: pi:claude-sonnet-4-5
> 
> Given the Assisted-by tag, I assume some of the analysis may have been
> tool-assisted. That's fine, but the author still needs to validate the
> reasoning against the actual code before submission.
> 
Agree, I will be more careful in next submission.

> Did you confirm that the relevant allocation and hotplug paths were
> manually checked against the affected tree? In particular, I wonder
> whether this behavior depends on downstream changes around
> mem_cgroup_alloc(), for_each_node(), node_possible_map setup, or memory
> hotplug nid validation.
> 
I checked all four paths against the affected tree
(6.18.21-android17-5). Only difference in
mem_cgroup_alloc() are cosmetic and do not touch the nodeinfo[]
allocation path. The NULL nodeinfo[nid] in Variant A is not explained
by any downstream change — the root cause remain unknown.

Thank you for the review.

Thanks,
Prakash

