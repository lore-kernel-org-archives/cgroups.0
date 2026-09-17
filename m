Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B361F370ADB
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 04:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789618138; cv=none; b=HWubXUjlHPvmRE46AMxQNaIC+CM5+EzH6zjdbPaCayq/7JsipAsdj+xDF+xKZDMEFQZInhxggkR0VwAJzvLisRHx4vU2Z3sa42/y5GiVcj7cbdirstisy5VfhdGbpfBezSyuHjKwH8Jf53dmoi8vi8+g9yjHQgsXKD+sKn+kurI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789618138; c=relaxed/simple;
	bh=90eSkqPcwTtZSl430/UWNYYptyYwyDsGB3QhMrAgVVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LnZF+q13lUDX2VuNeaqbxPJvEQhICAEj/OM5vHHRyldByG3xpc03WW96fKZC2zit0qzW0bYCYKnXrRKkqllKnZS7ZwnaZKiN4XtFwHln0LmCFJTh5U53j9wjHGi7b/Gmx6Qm5c2/DzD8weidiPLDBVGDY8G2r07QNuy7pvK5gGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Fw9noaA1; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=iMeeEnoz; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Fw9noaA1";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="iMeeEnoz"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2YtdG3509994
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 00:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=4MsU
	G70Wxa0eAr2SAA/0CgdYUX3vDnkmNZ7zeQKTXH4=; b=Fw9noaA1FqS+6l/o3z9T
	84pZlR5APSrMrHKrJE/h0+J/6xSiUOm2+7iRX1mXOKGEHYw53tUbgkoJgrKD+Isl
	M3twCkSJbl1SAWEgj4Yh9EMNmnbsx1lMChS+Xi/NR2pT5hrSrhfEhbYSIb6TNqWA
	DvLWozlsidXH9G87qjEYEwue/rf9A4N1VGpJU9IvQAjjbMblo+KqYpv8ish0k3fp
	hkj0itOozslY979hiF1+f4N8n+kb4SOi/0s99Dn8t5mb7+4T3+N7OZqyu2GIYdT6
	VNo0wOrx9JKQgEYqTCMun/mKsus/yXPsaO3yHbxCKrQ2NuFU5qUPoGyNlWaLt5xK
	vQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr3swhdyy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 00:08:55 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-532862dbdceso6123991cf.0
        for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 21:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789618135; x=1790222935; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4MsUG70Wxa0eAr2SAA/0CgdYUX3vDnkmNZ7zeQKTXH4=;
        b=iMeeEnozxC6qdwDazdYB8K6AKZTp1CSeCkHmGH5UJSi6PhVYv+rwGCmK86Vmcwlz7J
         UmD4LFTQCuVmho7qLNOwvr9PFqrAF3ruyUGVdnU+W+GmePqZyHcqNYzA7NYZLt4Xn+95
         nqt7wKZ8ayThw/IbXCZM2gAaH13rKK01aca203Jexvz4b60pbybwWYft4f6/dASum10e
         NQMLobtiqqM7pX9MBJYrYlb7TWQF4idXxNSQKxgAxrjxnsdTSGk3zvc272ErP8vcVnkv
         UNjJhifWIZvNu+v7rxwBh+hmv6blN6uYeznmQBAGgD5JN431blAcZYr3ZXsP+P+fkEzv
         xJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789618135; x=1790222935;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4MsUG70Wxa0eAr2SAA/0CgdYUX3vDnkmNZ7zeQKTXH4=;
        b=mgBQJgwvJHnFnSZnIAqjt2IZBSHj+29ajW42kg0738zFf7yXc/Kp+8eqymb2wUSrWZ
         9VPFPa7xtmYh1qc5VZc5VaC3lheEyWDuidwTDkd8A2c8DzLNuSR/ftordxDEwsrWpcvI
         xT+VGdsCJtpb2TeG0Lb7EBDqob4HAGUX/5+T+1rOzayUUoKkJ9Q7B5qqBPmMPP5Cd184
         X3lJQ9fRZboTw8lOUtIjJTKLj+69m/9nFjvWO8uDzj8E32QyVwa+ZndaUGWd4k+XkJ4o
         w/+6Z5kupDs1lsnywjBwFpvyq/O+BXZ3jHK2Ea4ZnrMxQjQO9/b4vZzzqf2y7zkvyEmS
         CiXA==
X-Forwarded-Encrypted: i=1; AKwUvBwbo2yZP9CSiCABE5pVwdXCq8t17w17cXR8lNU+SOblNuYrqXwruyxV+xICHcv+aX7raeHblCQ4@vger.kernel.org
X-Gm-Message-State: AFuF++m1ccTdv6wtgciwXQfktLPL3ZCMPcnNwboBvtOoUpIJLgYCctey
	9wjDlRdrRN6IlbhJYj3auBsoFkXwRCU7orRfLFI46EOJAETUoe1PG9R1AJXCrEZap2Vof2u+aWt
	7+ZokGHxmWx+9IMoCzGfqHp8o2DRClXodYfFT+ZMIajwo+NuZ6CKx+Ek=
X-Gm-Gg: AYBFou2aDRLHYgsrcEPzEdpZd6X1/jzunImC3haCNGpd59Dtf0RdE3q7x+4G6yDW7Xz
	87FHadKs31rqJnzv5MA4LK1shRfDOlHDluzjkP8pcjh0Jud2BIHjqejq9KVUv2AooCCoNGSlNTI
	2ZADWIxZJvuA0G35dpmERT5AiL4Nrlcqs6qtuIB7KR0EEvRc0YsdGalLRaBc3aISs3V4UMjOuSp
	faqQ4QrR9VA/51g3sGFMetfY5xK+CM7vhsoV+WtmPS6jOYRVW7CuBSQfxMwyirsVVx4PFMaGuP0
	KfvkRDx+M1OhA6Dzm5NmViqK9Mur8Rgvv8m8hOgynpFV6O3lUi4D+OttaK3eOTy/N05zk7ZkyJ8
	6p73NishOUYwTM6Pt1BETJzDdKEX6dTwkP0V2LEy+7cSKE9dNRw==
X-Received: by 2002:ac8:7e86:0:b0:530:430e:8126 with SMTP id d75a77b69052e-5327ef48422mr75468451cf.47.1789618135146;
        Wed, 16 Sep 2026 21:08:55 -0700 (PDT)
X-Received: by 2002:ac8:7e86:0:b0:530:430e:8126 with SMTP id d75a77b69052e-5327ef48422mr75468181cf.47.1789618134691;
        Wed, 16 Sep 2026 21:08:54 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm39536581cf.28.2026.09.16.21.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 21:08:54 -0700 (PDT)
Message-ID: <af7d1ac8-7ef2-4227-949b-21c3a9097158@columbia.edu>
Date: Thu, 17 Sep 2026 00:08:53 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/11] mm: memcontrol: constify the read side of the
 memcg API
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett"
 <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
        Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260916035222.GA19557@shakeel.butt@linux.dev> <aqrRewVuKfPk7y1U@lucifer>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <aqrRewVuKfPk7y1U@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: GrVf8LZcN8q6y23uRXiQyUMJO-YvSXvY
X-Proofpoint-ORIG-GUID: GrVf8LZcN8q6y23uRXiQyUMJO-YvSXvY
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0OCBTYWx0ZWRfX2aMXPHqdG8Je
 QiauUn/hPbZadhJS1eG0V9eP3dJKtPIOyLjYWy7hVCSyCpUchjk6kRrYnwDJNEeaN3uls9UiibF
 +7GibZv94dzRn/LKybSBJp5fcls/JRaYkq5AGsC0dKaghNsqS0Ei
X-Authority-Analysis: v=2.4 cv=ac30Dhot c=1 sm=1 tr=0 ts=6aab67d8 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=VwQbUJbxAAAA:8 a=65z7is_U1JLoJa5uI7QA:9 a=QEXdDO2ut3YA:10 a=QtEvL3ry9E0A:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0OCBTYWx0ZWRfX/ZSNQbLA+smg
 X6dvKkN9/wqLmt21L+cUt4sUgzZbHkaDd2L8uNEN2cAts9obxrQ9Q6ulwOvWVp+HGiwdwJiuyvx
 QpsgdavAeazWKa0REpM9qakFN4IUvdfsJkGB84CmPHkmRMasMGzakSrlyDaZ1ngCyo1Vghzq0qa
 yjAEb7WotUPTFdIhGJUZXo2nqw1EWwtRUR70sXLmQHZKod6NXGboU+szs0U9M7HeaPopHm3U1mg
 uJEa/3ks+NPd/RFXwNdFsY1ls5KxrdYspTBgEa7wRCFtr6a4wJgjQbYG0ddXvnO549MdAdl37SZ
 sD7FjVrtt0Gm0cXhlTOMAPzIuRtstX3UyCDSWj0pTfBK6vLxx/dCJVmtMakOwc1YXyz3ESCvdoB
 IhiGIqaUyWvysL7oCegFyq+PO89UNcDgIWwnAF3lX6FlXLQdIBfYjBlBi0gRd4b/KfZUEfIy0ho
 R+wtijt10mOagYKZZ5w==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 clxscore=1015 adultscore=0
 lowpriorityscore=10 phishscore=0 impostorscore=10 spamscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170048

On 9/16/26 1:28 PM, Lorenzo Stoakes (ARM) wrote:
> but obviously, equally so for v3 :) thanks for doing this!
> 
> For whole series:
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

Thanks Lorenzo, Shakeel, and Muchun for the reviews!

