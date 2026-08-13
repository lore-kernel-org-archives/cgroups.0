Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CB433A708
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 08:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611327; cv=pass; b=uCn1sa675NF6V9DtnzJN3qxK08vmjE4fxLsqaA1fLRVO++hrY8HNNshIpuPppklAMdqWQqW+Bd0tecHIRgw/ypMkgYMztaVTFiX1kFEYnUpaUid9XV5K9j0B65SmeU7R/F6l5y9dhDo0yir+otcU0DX327BxOY8YD4ZdFBkmywo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611327; c=relaxed/simple;
	bh=Jzc8k1yrWfBTMmPd/uTV9o0ew6ZOvHlbY2BVlHKCDmQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BgFGSQQepINFJld7384NJQ76jMHPBgu/97Az13bme7w5wTReIPc80ofwrv26Hxt1+zYuA3DJSszJpIClUZfkNmK5jlSBvaqrQNrHlK0p9kwZCxNRuH2pojd2aeGoDkJMMT5Ulc23aD9R3RhXogQbbcwAoX3M7vnD2rMv4uhesps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbbGxqob; arc=pass smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbbGxqob"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-ca12086c06eso433843a12.0
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 01:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786611325; cv=none;
        d=google.com; s=arc-20260327;
        b=TAEyKvZo3Q2rcSdZgChU+T1Qr/s6oFBLTjkz8shqJaI5Hu9ls2zWPVUByGgv9ioSsq
         Vk6rVht3sEoT306VWcfdw31Pt0jrRHjvTEK2ouRN4P6oYudEserWRmkEkNn23KbM2rta
         PZhXdWJcP5vzz+2sY5sAWFoVK7gPP2GMuKklsNkB+4o6cGugETvVWMgGkS575vZEtaEy
         vLehfMQdkuYWWfAF+O9+gCyBZsSgb04LEiI/N3zupK0IH5DJVUK3ujlXtARZcwjxv8Ki
         zL/ZOK64WIMLT3G9jT7cjIWnwowGntdO/eV0Fu6BLt3J5XSeLst67WiJRX0n7O5WTDOM
         RdmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iQkBGHUJCah+5IraL6W1VGnCKmw1qeB0IxjLs3arhcU=;
        fh=61PaqbSwvD0W+9CBlyCsf92FKX2LlFsA2aPk264m2l0=;
        b=JdCqG7pSHRavqulTqnsAuDU0AHkVC7Y1fiv7P2+IUijIYCA6655INd5J4G+ZECok60
         hiOpeG8/VY3F4SVOSMlzFf/egeTuFnssH6FE0KUB2hytL/Xca7QzB3NFIRehwVRudS67
         MqE+My2P7xK4wDjjiWWU7DTUcI1bCNawJ8CBu1NDXMcLOTWvYuwAxMAIx96tAmDw4GA5
         nfVP8vANT9sg9FYBopOohXkSetz3D7TfiJujR54fIoO/tpW1Ow/bZgtNmZRxEHzxI9Vd
         xDoLHD+zyIFhEH6HFR2uBvW8vzZxrl38DAu+lopdnEk/itUwXo1fvQ5VY4vKbsnM77iM
         tvFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786611325; x=1787216125; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iQkBGHUJCah+5IraL6W1VGnCKmw1qeB0IxjLs3arhcU=;
        b=HbbGxqobFGq6jQ6lr3AJYabpK7r73QkMm2744ocBEgZnA+6LW1VXrJFvpPuRvh7/I6
         TkJKTnNGFbwPfPQkY7vkUNbj4DBRuQjSPrawZdDMGbvp3sfiPH5dD18PB77MjXzZA/qY
         XPo7ahdVsKJJYMaLNASbJYMiZtJ3FafVpzNeEnE/PnWlf476KRrykV3FhC0tMDv4WnNk
         m0y7kATTGB+afK+bUQQPp4AkzCAB81Xl36TrhqC9hE1NujciAOnmDwqF8d/3lvCK9nW1
         K5Dw1FSSyXL13cknl9NsxPbL3l/9WzZv36eVpZthyccF8dHS7UWpyPrQ/uxlaDZPpdzk
         1zsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786611325; x=1787216125;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iQkBGHUJCah+5IraL6W1VGnCKmw1qeB0IxjLs3arhcU=;
        b=llZ+43HpTVD7fjlLuTH1+G/Vy1KWhonS7d8f6G5aX93Brg4DauB/uaZHfqzaqT59Xm
         XTXR/KDeZHdwrrCr730P9GK3fZSSt8g8aEFSgOyceMhSH8u5BjoTB40Ah8vpv8u/ZSYU
         Yt+tm9CqpI4JG2793tOXc3yTy54aVFN6qAFnvDLgA/mH773BNe021Tj8FWDW28PZ9U5b
         ZqlGC7BfilsJ3lEp1xyPiBYrqvUz2XiGe/wCPQdOfx6MPAl4BGX1uc0jfgw/vzMy2/3w
         QBHnRuGAhigqZ+ghPYe+4DhK+RSCCodyuAXQ7iUPmqRoxiek2zOUzH30RgGvLA2am+Za
         dhjw==
X-Forwarded-Encrypted: i=1; AHgh+RqSvhArnEwv4Oz25o0p1mag/gJ8GgnVmQxi3jAHLz35yLQhyK15uIqFw2pkBbzRW17xUS7uoWqr@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2VK0ViYMWLfDPk2S+O0/QRkLDwpgYzW/vkt/YXj4F/LSKs9X+
	4OUmDcmE4UcbBYdAX9xuCCSv1oTj0GnBPm5TpjjCp0JBFraF0Hu7K5NtwvpgcqzBqbKysM5eQIb
	Ulf4uoezEKIOZ5tKNerYMp6kGMPNMxWc=
X-Gm-Gg: AR+sD125sG/Lb8Z9Qjk1i48GFT8WoF8lLd38z00B9Gtg4VujiqsCGPk/XA4ig+PWpa7
	1q0MprrD2zkYBb0iO2jRsVO0LQtiykMzWRJamPlBT/8+GqA/hLJcQaeo0emdyuKTeeldJF/tHZA
	/tUrmzd7swr7WQ3KDwGu5bt3RcCvEpjXrD3jiQJzDP8zQrwJwmZQlt2wsFP7LgD+SmpwkAE7vH9
	86Z6eBJOK2ZnLnkLRukeDZGioVvrMJcNndAxcA4IvhJTMaenvfNqxEDpMv8YrQikYi3UVo2Ue7x
	S8ygkUMA4UvdoHetKHmNlXHBtJfCsQHS99H2lt9MGIsR1sk=
X-Received: by 2002:a05:6a21:150b:b0:3bf:8604:9a3c with SMTP id
 adf61e73a8af0-3cc553f513emr5787899637.28.1786611324791; Thu, 13 Aug 2026
 01:55:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720193431.3841992-1-gourry@gourry.net> <CAM9Jb+jpJ-Ui4qDHxsp2WiERiv8gmrQfKQ8Z0BmabefeQ6pg4A@mail.gmail.com>
 <an0cAMh_m8ZhGIm2@fedora>
In-Reply-To: <an0cAMh_m8ZhGIm2@fedora>
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date: Thu, 13 Aug 2026 10:55:13 +0200
X-Gm-Features: AUfX_mx5aRT_GeBsew982Oll4m1v2zeTSERp4DtDb2YI-VK1slYjLWUFWPkF2ZE
Message-ID: <CAM9Jb+jmxPdL-CdWQHYMT5G=qmjB6z2WFg+4K8Fod5n=2N6YCQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
	djbw@kernel.org, "Gupta, Pankaj" <pankaj.gupta@amd.com>, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, 
	tj@kernel.org, mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, 
	jhubbard@nvidia.com, peterx@redhat.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, usama.arif@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"

> > > Bonus Configuration: HBM device memory tiering
> > > ==============================================
> > > echo 1 > dax0.0/private       # make the node private
> > > echo 0 > dax0.0/adistance     # highest tier
> > > echo 1 > dax0.0/reclaim       # reclaim active
> > > echo 1 > dax0.0/demotion      # may demote from the node
> > > echo 1 > dax0.0/user_numa     # mbind()
> > > echo online_movable > dax0.0/state
> > > echo 1 > numa/demotion_enabled
> >
> > I am bit confused by the HBM device example being discovered as a DAX
> > device. Is it to
> > only to showcase the use-case? Or we see HBM device is actually
> > expected to be discovered as
> > DAX device with N_MEMORY_PRIVATE?
> >
>
> "actually expected to be" -> no.  there's no requirement HBM be
> discovered and boudn to DAX, DAX is simply a convenient intermediary
> to memory-hotplug.  This is at best a demonstration.
>
> A device driver could very well just call memory-hotplug directly,
> or its memory could be brought up as a private node via a boot
> paremeter (which I have sculpted for v7).  The former is preferred,
> but there's a bit of a chicken/egg scenario for bootstrapping.

I find this interesting as this appears to be evolving towards a vendor
agnostic framework for hotplugging memory directly to private nodes.

How you see this working? In particular, How would the kernel know which
memory ranges correspond to HBM or other device memory?

Please also CC me when you post v7: pankaj.gupta@amd.com

Thanks,
Pankaj
>
> Most of these UAPI extensions are going to be consolidated into a
> debugfs interface for testing purposes only in v7.  I've been working
> on aggressive Linux Test Project test expansion to ensure there is no
> UAPI regressions.
>
> ~Gregory
