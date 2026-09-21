Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2E949A3DC;
	Mon, 21 Sep 2026 09:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982929; cv=none; b=acpyy6ZXnHuo/bglX5iP+YPnmBGw+2uBydQLi4Z8QCqujtaETkfJ1yeTJXShP1+UpaaQZrd0+4iMF/sigAOTEeQ0paFyiuMGqopmLIw2ILPbTQHVNOJBUFc70KpmI1k6+Dy/BBwmndUovD7A56cQEnXqzmyFs/wdQ+R3pwgkTNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982929; c=relaxed/simple;
	bh=2ja0iXhncaSOLX4279w1X4woaAq7vhERXDmpS9kJ4oI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ih8zIlNSwccfcSU66qdyvXz0L541S8A6VJreZ+HsySScI3WUuruiGq1D8ycNLCyIp06j/de3lzZL7fa0FEK4dGvYsIzN0ecZMWtPmth2wWEA1EuGgWhaFsWjOeWgj+BnhnGGJedQBMwy9aWBD+nTS96KpdnBjPQ+Kr3dUMfq0JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LbpNXzuF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LbpNXzuF"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L7ZbnX672354;
	Mon, 21 Sep 2026 09:27:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=G1939M
	Elcb2kM01/7HPbHzZLx6pN/KmlSSE/eI9FBUg=; b=LbpNXzuFadRu4xefU1BRaQ
	h06fCzfQKzfgJVO+GdlysRBuw3CYS0h9INHzdvY3mycdGE8B4aCXmajbflhXM83m
	ptcP7kCNPw7U5yE7EQVhYZbolmvC65PE01R+sPRX1TAwDsp3zu59hoqOFt/AvSFu
	5pqA8S4gXwqDoq7dFjtx3V6977yRg6lME+gwPDU4gqT+I3OVD5aSSVh7R8w6dn0T
	kiKHMCbbohscsdNiKn1Zx2pPlBr3PIYgVRxD/D5LlFRG64591dn0jOnilV2QvhBv
	bToDpdeuPAeQZrnWFVRBLnCUhYPuTDfHfi8SVj+Rm2GBZJhlYSmRWoRw9xze2Cvw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske17ksg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 09:27:30 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68L7HTui924403;
	Mon, 21 Sep 2026 09:27:29 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gt4qq4sv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 09:27:29 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68L9RTIS62783920
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Sep 2026 09:27:29 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAD7558063;
	Mon, 21 Sep 2026 09:27:28 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F3D55804B;
	Mon, 21 Sep 2026 09:27:14 +0000 (GMT)
Received: from [9.61.138.180] (unknown [9.61.138.180])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 21 Sep 2026 09:27:13 +0000 (GMT)
Message-ID: <37de70f6-67f8-466f-a267-03584973dd3a@linux.ibm.com>
Date: Mon, 21 Sep 2026 14:57:12 +0530
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] blk-cgroup: store blkcg in bio instead of blkg
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
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
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
References: <20260920092351.2434283-1-yukuai@kernel.org>
 <20260920092351.2434283-3-yukuai@kernel.org>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260920092351.2434283-3-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: -Xd8a0RVEhrxDFm6gn4h3GOonDYckOi9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEzMCBTYWx0ZWRfXyA4xNH3cYzqc
 l3LhAHGkDdB9wr6wJVvzkOiW0PLTrY+6N2xnfwVvAXBEgUZUUlnqQoZ9S/t2ec53rKELusYcvWT
 di0gP2G3AgYQrqIZGwv4XAk6ZTbicrvfmdi3M2UDvbThVuKLxf2bVg5EnsFXBr4KXrs6etQpgoD
 euKLu2Q+XaIsRVuhlHm+asbpr7zvK5ks3HxoZmC3tfKIKTo9gLj/L+nXXm8Qa6LpaYS6fCQWKwA
 rPtKbOsDw0UQzNsyd8H9bnPf3SqR3/y1I/PXuxjss5kLLxairvDG61ZUizIHrj9aHnJa9muRUGp
 7oMtV5GSfddGruww+e3uDCJcaCC0OqzGH5jLo19DzokCNvtkRFr5gRuQY3TQAjpzacqfLjYt61q
 p4U3ri+iYIaoZm7NV0kKr27cQE0po2JDzt0VLOolD+KbjSIIi30aCQOJhnnHY4hngd24Su44C9I
 iTTkkhvJogiX4hApA1A==
X-Authority-Analysis: v=2.4 cv=O/KsLx9W c=1 sm=1 tr=0 ts=6ab0f883 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=yt32EUx3BFOMUVNgjeUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEzMCBTYWx0ZWRfX5rV0t/6BeebN
 XqLIK4QGbSN4xT9UKi23paOxlW7Ykt3xnAjLGUCmr0jYvC/s6nTF8lOI7DuZlUqbCJZ4FsSaWjL
 tAtASM6ortzkp/bMC84v/5e+hKTSbak=
X-Proofpoint-GUID: STTiMO6o3fOhik_S7E0XjsEtuaK9UoBW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210130

On 9/20/26 2:53 PM, Yu Kuai wrote:
> From: Yu Kuai<yukuai@fygo.io>
> 
> A bio currently stores and pins a queue-local blkg. This forces bio
> association and remap paths to look up or create a blkg even when no
> blkcg policy will use the bio, and ties the stored state to the current
> block device.
> 
> Store and reference the queue-independent blkcg in the bio instead. Add
> helpers that lazily look up or create the queue-local blkg when a policy
> needs it, and pin the result until the bio changes devices or releases
> its cgroup state. Look up and pin existing blkgs under RCU, taking the
> queue lock only when a blkg may need to be created.
> 
> Keep completion and accounting users lookup-only when they do not create
> a blkg themselves. In particular, blk_cgroup_bio_start() only accounts a
> bio when an online blkg already exists. This avoids creating a blkg
> from the unconditional accounting hook when no policy is enabled.
> 
> Protect every rhashtable lookup with an RCU read-side critical section.
> Annotate the lookup helpers and recursive wrappers with
> __must_hold_shared(RCU) so Clang can verify that contract.
> 
> Before entering a bio-based driver's ->submit_bio(), drop the pinned blkg
> after blk_cgroup_bio_start() has completed bio accounting. blk-throttle is
> the only policy supported by bio-based queues, so no queue-local blkg
> state needs to enter stacking drivers. The queue-independent blkcg
> association remains attached to the bio.
> 
> If blkg creation fails while walking down the hierarchy, use the closest
> available ancestor and update the bio's blkcg association before
> recording the blkg reference. This keeps later CSS ID hash lookups
> matched with the pinned blkg.
> 
> Signed-off-by: Yu Kuai<yukuai@fygo.io>

Looks good to me.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>


