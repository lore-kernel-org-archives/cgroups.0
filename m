Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437CC3B27F7;
	Mon,  3 Aug 2026 09:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785748184; cv=none; b=okB+QuHs5QM7U8JQfQjMKFy6pxdVwEgRArGqOTNFciYZv7VCZXTvekmOvRbQ3cHyzN8G1aFpcnnJyWbWO3+YN1rnmnDPTjvRyODww56zB66zIs51EoNQoSTQ0OhWBGVWb+sb0BP++J+ABhJGDW7K+8LULWhwFAaXMrdib6Mi/tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785748184; c=relaxed/simple;
	bh=fOsJskS2gBigJV3rB7UewgfvC4nSnZZgw2sq5IYJTcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qy1aFbJqasdIbY8QTAuEzfz60qSjapaRf9R8KcndQWtmPzMZ9XU+/t6f7LVcR8Q6c99Jr5C3wiATk192YgVUpjQB0PlhyqQndWgOV74Eg+mVTjDJoxDS+nLvrFIzSyBB2RNYmzF10eqr9RnoGG40SRoEPPW8spUO2zLkaSiohyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=j9x54CX6; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="j9x54CX6"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672Lm871291377;
	Mon, 3 Aug 2026 09:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=L8wxDL
	qgdWqadmxIkNpv45akN2L6pouN4nzV8MHoZ4I=; b=j9x54CX6aJ1/WyoApsTCg2
	o4uDZJsJWsK/NjroworutXmX0sC7TUlQlKRRp66hn6uJfKCB5CTV9qS0u1xhJDES
	wfBoKt5EPexgIRZKe/m40U8J52wHHSgkA9DD0mw00fMh/780anr1xaYuw6pweSts
	qnpfeQNhGVcadNVlTp04DLfTbha0K+w/ZMnN/xw+VigMeIxrNxzU3+74fz5FgqEz
	Bo1R5BGhyKS3mYEdh0CJpgpSS5G1qDt3IHtkEcFwqAa1iBsRjG9xFB2K9IFypxnH
	N9H+UGksPvOYwNf0jci2OzY98mFebQjSck6pIL6kOuT3cTVv/qQfIY9hEl/LidqQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8eufjte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 09:09:21 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6738uIRJ007166;
	Mon, 3 Aug 2026 09:09:20 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsv4jvnpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 09:09:20 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67399JqA2163252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Aug 2026 09:09:19 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5EF495805D;
	Mon,  3 Aug 2026 09:09:19 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B89458043;
	Mon,  3 Aug 2026 09:09:16 +0000 (GMT)
Received: from [9.123.7.57] (unknown [9.123.7.57])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Aug 2026 09:09:15 +0000 (GMT)
Message-ID: <523e4487-4ac8-434d-bebe-03ae8212b577@linux.ibm.com>
Date: Mon, 3 Aug 2026 14:39:14 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] blk-cgroup: fix blkg list and policy data races
To: yukuai@fygo.io, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengqixing@huawei.com, hch@lst.de,
        yizhou.tang@shopee.com
References: <20260802112525.3933753-1-yukuai@kernel.org>
 <431ed2f9-9fde-4ff7-9db7-51a56bec17c0@linux.ibm.com>
 <055d481c-dbfe-4749-82f0-49e330724d86@fygo.io>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <055d481c-dbfe-4749-82f0-49e330724d86@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XCjIQ9IOPkvhEFIOo8wsvYedr-Y8wWny
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA3NyBTYWx0ZWRfX1vDX06BnoTaX
 3/Lc+lYcub1ROPT9V54i4XMEoKQ0Fs/3A8uuJZf555lTG9oWIo3yI2fmmugpAnpb5e8FDXPcdTH
 3TyGdWMtinSgRwVJdCCoSsoIYaQzdWA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA3NyBTYWx0ZWRfX+0KbfQo+B3za
 DG7EKEw6BJLisckpp0V9DAIpd8xyyuCLXzKAoVwTtz6ntgw5SpEn8XxfmOKNup06eqaNJSVr0mD
 IDweyYkRau97vtOM+amwg8xFkJ+1rJfN7UxL3Dx4MHcjXv2BIsDQ32i4bZvi/SBrkUJzvWyyA41
 ovfMJQue2ZJcLnt3tzm+ylLMaPm0EfTdI2u8zBtJeTTeVYZCs9/EHlR+8wfZM+Xw74XF9QxgPOd
 FUUWIC8SdYLXYjlsRFEKbv5DQ2WG+zDotQk/MUWkvvdCqPN0CZjHxDwlcgfLDemXljHKrGkcIt2
 LgCx3zDsvOHwBqIa42YPc7PrJkiVG+HJYzzuW/oLLA7oM/p6jGZQf8thfodKGWezYL+qtaHUHBb
 mmXiJRhzmPkwugAfdZwtC8zWeew8FXsSOeIRAO5FF5eHwt+cyowWa0I3cS/efNl9pUWxeNjNHN6
 +TZ0bMxlLrT8uinDDZg==
X-Proofpoint-GUID: XCjIQ9IOPkvhEFIOo8wsvYedr-Y8wWny
X-Authority-Analysis: v=2.4 cv=KfzidwYD c=1 sm=1 tr=0 ts=6a705ac1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=9tl1nHjhYCbjcLoMjjMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030077

On 8/3/26 1:50 PM, yu kuai wrote:
> Hi,
> 
> 在 2026/8/3 14:51, Nilay Shroff 写道:
>> On 8/2/26 4:55 PM, Yu Kuai wrote:
>>> From: Yu Kuai <yukuai@fygo.io>
>>>
>>> This set fix some problems that are reported long time ago with
>>> minimal changes,
>>> the blkcg_mutex refactor I'm working on can fix these problems as
>>> well, but it's
>>> complicated and may not land in this merge window. So I think this
>>> set should land
>>> in this merge window first.
>>>
>>> Patch 1 protects blkg_destroy_all()'s q->blkg_list walk with
>>> blkcg_mutex.
>>>
>>> Patches 2-3 fix races between blkcg_activate_policy() and concurrent
>>> blkg destruction.
>>>
>>> Patch 4 factors the policy data teardown loop into a helper after the
>>> race fixes.
>>>
>>
>> This series looks good to me, however as I recall, we discussed about
>> protecting blkg_create() as well using ->blkcg_mutex. I remember the
>> blkg_create() is not protected with ->blkcg_mutex under each call path,
>> so would you to also cover that change in this patchset?
> 
> I can't do this for now without a big refactor, because it's possible that
> blkg_create() can be called from bio_set_dev(), and bio_set_dev() can be
> called from many atomic contexts, examples are patch 1,2,3,5,8,9,10 from the
> following RFC v1 set:
> 
> [RFC PATCH v1 00/17] blk-cgroup: protect blkgs with blkcg_mutex - Yu Kuai <https://lore.kernel.org/all/20260704195124.1375075-1-yukuai@kernel.org/>
> 
Okay understood. With that, for this entire patchset:

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>


