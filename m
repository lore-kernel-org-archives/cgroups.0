Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792561626;
	b=dcKOH40MPqkMTz1b/q/Z3R80lruHhyXKi+iUQTMC93z4UZ8DImzWoqBLd9mrWce/dAhB
	 wpDSGkzW+weT+1hOlg1I+0cwm4YVayJD0O4ZQRwUfXC1DWK8t3mvKFToQBTZ9lbHPUwqq
	 03jtqRkusOXQvAqXR/0HDCD9kT9MJDDSyoCRia/bxMKKnAocLXkRGKW2tTrqJmDaPpExF
	 nFdOdVRyZctYU3MQfhQSlYANowiLL5GZYdSsYpM7H+W0Mz7aYzcku/vBQSIo+jSTfMEF6
	 UJi3mp5A/udWO6q7EmV9KbmcYJr5MqaokjUndkNX69tAeXa7nPSMAncC49F9AYRn+lA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792561626;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=tSn2dX29VgDqk2hgfuzvCjkC5Mz2yIfzdQjrFRKGhV0=;
	b=3fzGx6XloThKfAqVwDLP/B7T4OGsrPCrVZKve7jRoPzdZp8XSDy9G0jG1fdlkxtxIoTW
	 WD2hFUBX3l6lbZGLjKZAnZzYnSuD9r+qxL00g7YD1ZQ8MA1zdpsunc87K9tqpJ1wZ9pZo
	 a8Qu8yLbGgccudgp/w8XfCnLHfWqLxjfMW0ISfOduGRD/yqPtTYrlO2/m3Xq3DCVBFywx
	 w3j8n16pb8SWmC2rEu5/XTuvC8CxOeS7io/jT4JiLjPffEQnElFhVmKs/UYnEYQ6hTFIQ
	 mI40zubZr5O+V/z+i2YHTXU1cOjhgHRJylYRjhA1c4syhV+j21cHRjRSCv907oma7ow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PPORQrRF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.41
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B95606A31B
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 05:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27B95606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PPORQrRF
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-679a420b5afso304495d50.3
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 22:47:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792561625; cv=none;
        d=google.com; s=arc-20260327;
        b=NRz8AEdRRBJpZz8FiJ2evGQdPq1tA1XafwrK2N3Ul4sZ08FMN6AWN0z+TFxFIR/I3V
         jTMLGwinr/w47gGvIzacmiaav6Lag1e/zH3WSWUf/ObpBVb5Ha0MRBytD/F2w42j5LFB
         Jw4LKVODzZb6FVgMA6GpGcrNT5/W2NbrESKpC6XrtZYF3Kf/q9p3Mbl9aF7Da17pNawn
         3rQMBhLFJaAYz/Fe1L1qrDTSPj+F4YH1+zFlccWCsISDVFLpJvoY0r6/bdP+38EvNd9i
         OLdzXV6TX+5TDC94oyA9FqOzCsGrBJOs8vzSFaiqNrzEhO192k2kvg2lYMegrW1zXnjq
         JMUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tSn2dX29VgDqk2hgfuzvCjkC5Mz2yIfzdQjrFRKGhV0=;
        fh=OHiKHIptb/8HxxtRu9LmhevalQZWT+NT3Apa+Wg7iLA=;
        b=GJUBzV00I8Gkt5ewsp5N79uuGc+7a/oSpp3MRi6VGLK4DVr4eDqQY1bblWaqDqclmN
         98zQhlxOiTQnKxyUqV3oVPNVzUkPYsAuecZ1Gz2pA/w/J+sFJXRjwCQCMhP4BiWqx25w
         19W9FqtTQwTOmMjo9g/pvIrSRMRE56CRB2qoOsUGlWK9KUIHjwE/ifbkrbuVmLCXFOtM
         A8oL88vw1lDnvvcPxfTtKZvolsSxEmwxrxIwBS9CPw+ujp4o8/sRtB8ivZfvCM44RkBu
         +zOA+lwrmddeiUjeQQESU8eV/yJIIU9tlVZVxuUxtSOz163yibgXVirmGBotxa1H8CvH
         vVXg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792561625; x=1793166425; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tSn2dX29VgDqk2hgfuzvCjkC5Mz2yIfzdQjrFRKGhV0=;
        b=PPORQrRFn7tZ3dUbqNotr7EMNnlKNVNCXlWCGZrOyaBVAF9EWlt496mVN9F89V7iIW
         Dgvr1ssi7Vixkf1DCoN0fOT8+ZVAK9fR5LesXxVuAcuXDQAjK40EmYAPUVU/21thJ4AU
         qvkAx7aSPuCZk8yRSQLOl1PS3sGcsFbyuZ1+JqblSWUrGt76EBa4/gW6XVdzBs7oqjam
         CbJzFige92dXRxMnPYrygO/mjvUjCCb1CYDB44/oE7PwgidEFUdRT2fzOfYRRdzwIMxR
         gsWyk0zV1rZLN5BHtIbO3EH+G5c0ZH/VtiIdvXbunKzIW3vbDrZ108f0vlFgOnu9AJXw
         c6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792561625; x=1793166425;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tSn2dX29VgDqk2hgfuzvCjkC5Mz2yIfzdQjrFRKGhV0=;
        b=I7Ni1HORa0B131eLLvR7tnVbeqRpXu9mEPN0Fjn8VG3USOsxwc6fkVTKUrcNDnzeeC
         OyjWQOGt2rgdA7Cq+7LqhgfxxwLGczMC1yraRnV4sIl4ANzvHbjfkKpLRDWEw7zzNBz6
         XMQ1GokU4um5NruibN9D+N5QxRh37LcmvQvNbpWX9cAPGzWXW106IkbUskIa/crgkUaP
         tUx3sVaxr6OBpiLvzFYlSqKlmD9Ccpy3rdl4lxeF7R/x0yFYQ/cAAxWuRh5qlOCdY3X8
         nm1hQ3BdbJPgm69kdhBpsPsp8Fpby3hoonjxm6dvKEIwSPOlrv2w/J/QJXAD3Cn8d3N5
         mxTw==
X-Forwarded-Encrypted: i=1; AKwUvBza9CRTdzr2Ba6WmqMTtyMpYqfmWVaMbAVZelrphQW4B15sye3RbAYU54UVlN0v+nKtYRj7cEzy@vger.kernel.org
X-Gm-Message-State: AFq9FYLINmbYqYCad31/mkI1f/3oY0Wwmud0Z//IhW1F4F4o/HyEptH3
	T/d04itwhXPhHChpmFNLvvLaXLnxXmXEjA0GAM+4W2YL5tl/Q/7O/b0rccxJWp3Y2k2v4mrmDdb
	JmG47jEGFXPMGwLA5ACJV3g++ZSFfI3I=
X-Gm-Gg: AYBFou3Ch/TIou6E4r2VA146ZUlvt4ko9CjElI7EkShc0a2rrXmWyXlpIbDtYf4ul1N
	X45hnohDHYJipxKXdfeUi3e21JvyDYzkE8o/dUkli67VMSmn3BCoqyp7ut5QL8jRQhwgy8+oQpd
	YJqrGGsWs1mgHAqG0mpcEajX0rWhH92F1n8K7tPwMI1MYAnmUeknEajMQ/ClsdG/dL9DjsWQzh5
	Iadr1FAFXFToklJAJQlPhVGVPBh1GqMdT29SblmeYJPUWMtZnsR4i1KPHx/QDVnHeLGNYGIXgB1
	bW5aeLmG4Yr54E6xQapbDBCsILUuUbQCYCVE8Vxz3za/+szA/WXkAuI3nEWSLAuaGJCoTLCCNGP
	4AtU90Q+i39270vNjZl7/RuOBlQL4RwKzlLXpXgLkCEHVW8rGVGbofeLEf/ZoWXWKwV18OH2Lev
	kk2Xt0FMjbD/mk
X-Received: by 2002:a05:690e:4390:b0:677:a7ac:5624 with SMTP id
 956f58d0204a3-67a0e4bbea1mr386088d50.44.1792561625107; Tue, 20 Oct 2026
 22:47:05 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019064157.29885-1-laoar.shao@gmail.com> <20261019064157.29885-2-laoar.shao@gmail.com>
 <179254940965.1919196.7604748267690139512.b4-reply@b4>
In-Reply-To: <179254940965.1919196.7604748267690139512.b4-reply@b4>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 21 Oct 2026 13:46:28 +0800
X-Gm-Features: AclHuK9yUw3q9bz6eHz4oS9_OplikvSYcNJ_NBkBIXr9uF4A9eTzN6CgKR5Bujk
Message-ID: <CALOAHbD_1rRWk+T4JU9gbQpjCnf6FnKmnj70U7G7CgWXdp61EQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 bpf-next 1/5] sched: fix stale get_pref_llc() stub
 for !CONFIG_SCHED_CACHE
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, 
	bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 10:23=E2=80=AFAM Gregory Price (Meta) <gourry@gourr=
y.net> wrote:
>
> On 2026-10-19 14:41 +0800, Yafang Shao wrote:
> > Commit b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_g=
rp
> > to fix UAF") switched get_pref_llc() from taking a struct mm_struct * t=
o
> > taking the task's struct sched_cache_group *, but only updated the
> > CONFIG_SCHED_CACHE definition and its caller: the stub in the
> > !CONFIG_SCHED_CACHE branch kept the old mm_struct parameter.
> >
> > Fixes: b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_g=
rp to fix UAF")
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Tim Chen <tim.c.chen@linux.intel.com>
> > Cc: Chen Yu <yu.c.chen@intel.com>
>
>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>
> Please submit fixes like these separate from your series.

Thanks for the review.
I will send them separately.

--=20
Regards
Yafang
