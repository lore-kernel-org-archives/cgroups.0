Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB927356751;
	Fri, 18 Sep 2026 05:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789711182; cv=none; b=E8nK8YI0ItlzKIikBwEMCIBU+RtG28cTWnlxMXEyUwc/d4TXqhZ3WrdJOryqQ20HFMeyUoNXCPm7z22229Tv2EjWO1ygT/7sPUDlvMV7r9UN3VuQzR7WJ3lATyFnvES88s2dDEbb6JYgYa8htvTMr0xzFw5FHVBcSedsnsRByPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789711182; c=relaxed/simple;
	bh=mJTN91ugFwjKMz4I9/XHV1un1QzWKvooR+gPxPOhWZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K88BHYwJsBxBqL2P+pAC/hmriW+B4KsKEVSuS2qgVugQZE1jzGkibJVF/AzX9Srrvsgada32Kw1lpe3TX0ZYPjGWvWf6KhV8AyuDDF84GCUBimygIY42SxixTwFY7eCasgym69ZWe+2abae7jzMFrJzzlALcire+8fymnyithDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ncb7ucBQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ncb7ucBQ"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I2VjZx043142;
	Fri, 18 Sep 2026 05:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OkKG5e
	Hj/nYQoAmDG+rhMWoq3O/eAaBCq9IsR6KTnK0=; b=Ncb7ucBQiJs7MT8jp9Hogw
	KABJEWlOfG/dfbLL7sZXrcFtqQHDCdSSDXBhPAMUuhs5npkTH7xSnz/q0jSWnr5c
	ZCC+Z9ZhJ2KpZ454Fn/KC2n0Cp1UhVDSe8NFhDep6X9wG98D2tZxBsJtHEJV+45S
	EjULYJaU5L4OoJZA/qL9KCw7HIyFbmDcr8Gxlufr7nBlme16tZiYsBgiSeN/5+3e
	Nn0Z96JqJXvZkkqBRVQed78H4ZgW5hfnssCzeXUxadsAKb1Eb+ftmmjqeYG8wl3A
	9m5u+yGoAqzpnXlfik8qPHri7xqtulz88Ch6zS0Mn2/FCTO1TiNWTPWug9fanXnA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmx846f5r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:52:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68I2ZKuK918969;
	Fri, 18 Sep 2026 05:52:56 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gr7genjra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:52:56 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68I5qCZX3015250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Sep 2026 05:52:12 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B0A5E5804E;
	Fri, 18 Sep 2026 05:52:55 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 876455803F;
	Fri, 18 Sep 2026 05:52:41 +0000 (GMT)
Received: from [9.61.58.220] (unknown [9.61.58.220])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 18 Sep 2026 05:52:41 +0000 (GMT)
Message-ID: <1742b0d0-fbdb-433b-b2c9-b47b5cfd7666@linux.ibm.com>
Date: Fri, 18 Sep 2026 11:22:39 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] blk-cgroup: move async bio punt state to blkcg
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap
 <rdunlap@infradead.org>, Coly Li <colyli@fygo.io>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
        Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Bill Wendling
 <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>
Cc: Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
        Tao Cui <cuitao@kylinos.cn>, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, llvm@lists.linux.dev
References: <20260918041744.1526924-1-yukuai@kernel.org>
 <20260918041744.1526924-4-yukuai@kernel.org>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260918041744.1526924-4-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDA3MiBTYWx0ZWRfX/teiT0wiHNSW
 JEvRLv8jYQnWWkxliGMH7Y5gxw8A38G2pBCriGrXSm3DN6Pr3l9Oia/Cs3vbs5x2dSUFWw1cfFz
 f6YEK9tOomOpksip3Jp/NjjN7rrYdt/gOI5v+6Y8AX7cViJK8cnyaAE3PjMik7w12aaXKvh6tPK
 tFBlkzqye1G3IuT9fAG8wstP9g6OAj+fQK4ugA5oL55w2miRU2d/M5YZzNY15Wjk04uncsH6aDp
 pnj11j8nfR0QxLHiscSmDcegPweYS/JObE2+bA7JB/xXyGgpQjesnbr/WvDVc+wx6dyVbrWXmva
 TRZBv+CiIDmwlROqGoPTmI8+6j49IF5vWsKy4421LSK4L8hh5RZqcbHHtqWWNbP4U/H4xAE0VIg
 qjhdgXfijXio3Cfv4RwZ0wphiapFt2dpjyauojKMPHivJdWmZuJs2lOfIk/cS3ryMpVrfiI0Gg9
 /PO92Nr18Ody/I9Qj1g==
X-Proofpoint-ORIG-GUID: IQzOuQqhULLvUviFRAhVAHKgtdnFYey7
X-Proofpoint-GUID: ZGCkVPtmRng54Q_CssYM4zmrTg3B8e93
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDA3MiBTYWx0ZWRfX7hqucrhMwMz+
 TMaoTQdDqBi4VtgFdBweWtZanWLjNVsk/ptq6fmVuMGXmra8Z54mRVbadv0oTv0nx+NSQH+0ts1
 oIkWCJgjmb268QlqzkGvSbLj1oWUnos=
X-Authority-Analysis: v=2.4 cv=cY9HPXDM c=1 sm=1 tr=0 ts=6aacd1ba cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=N7Slw706a9Tpp8ivUyUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_01,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609180072

On 9/18/26 9:47 AM, Yu Kuai wrote:
> From: Yu Kuai<yukuai@fygo.io>
> 
> blkcg_punt_bio_submit() currently queues punted bios on blkg->async_bios,
> so it has to call bio_blkg() to find or create a queue-local blkg.  Bios
> now carry and pin the blkcg css, so punted bio lifetime no longer needs to
> be anchored by a blkg.
> 
> Keeping the punt state in blkg can instantiate a blkg even when no blkcg
> policy is enabled, just to bounce submission from a shared kthread.  Move
> async_bio_lock, async_bios and async_bio_work to struct blkcg, and queue
> punted bios on bio_blkcg() for non-root cgroups.  Root or unassociated bios
> are submitted directly.
> 
> This preserves the priority-inversion avoidance while preventing
> blkcg_punt_bio_submit() from creating blkgs that are not needed by any
> policy.
> 
> Signed-off-by: Yu Kuai<yukuai@fygo.io>

Looks good to me.
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
