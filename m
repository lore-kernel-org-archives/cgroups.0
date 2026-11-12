Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794465661;
	b=5ReMS2uZJLvW3/WcaPx4IGr3Vj1hf0Q03rOhjnu341aXucY5FkjsvvwHUSZnjw1ConNc
	 jr9CVqReUvtPh45g+qHJ5S84shLdEY7IZf68yz7Yzd8exZY66aczdf/HL0qaqc9nMAwoZ
	 iCT9INIsjapVVfS08oCHF47L8CL5Gm2nLbHLEo4I1TA3vib4CZoT72L50x/maZfqOB8eZ
	 bg2Dy7I4sNYiEq7EBaWOuDS3+ZlFk2BtQG5ni/euwIs1T+/6EH6lgxsAmC2F6ob94RTPE
	 urEWnJ1xXQZBBxddcLZy/E3pa0aIgoAt/NHNvtHahveNChsHN3fWKJBoslYG0TrrLMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794465661;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=8vDJ3Ou7xzCxze/52XPwkTIU2JyVZ1LI+BGZWXtekYc=;
	b=ScbJt6kGrZmsqJAtLC2k8a8TiLS7X6sCIvcF+RjMP4g6bXUmOEMCqzrP8FDVd+7dPD3J
	 sqwZCOmInd6A0oJCPY+RrGSJAKEvQpnF/vw65nJjDpx9RDHXHD/LKpUsdun7H41Oavi7S
	 joTiZCobAaXlxlDyYH85H5ZiWuuH917t4KVs2s+Gw2ZtMnjhaXQ4GAgVSBfdVBGWpExDr
	 pQ0c7fMf6z3MAzbRA0mn4LTqSyqYLk7qHXeiI59GaC+5vzxwbf29TaNoXb1EHWMHlYO44
	 ksdccZtltP7doxDhIn3nc6DnqzBNC/vNzyenztXFveWFbAwZ9rO5uZkZFT/mhdMntYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OyPZjAqe;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ZtPfFQBc;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC549606A31C
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 06:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC549606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OyPZjAqe;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=ZtPfFQBc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794465658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8vDJ3Ou7xzCxze/52XPwkTIU2JyVZ1LI+BGZWXtekYc=;
	b=OyPZjAqeZ4C295wMwuJ91saWYjokVhEHzfEaMFdy3a1GVeo46kGVTjH86hEV3hDoZQvNQS
	f4MMCSztRPT0yXDBdTZKHOfCj0nEQMiPNuVwRh+LEmhWgmMyC6BH3D13IymFFLXK0tbcVH
	9xDTCKvMtgvhmRyv+TO9THOEQATIA10=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-lgl4Ia8YMCWOb9h_2IG3tg-1; Thu, 12 Nov 2026 01:40:57 -0500
X-MC-Unique: lgl4Ia8YMCWOb9h_2IG3tg-1
X-Mimecast-MFC-AGG-ID: lgl4Ia8YMCWOb9h_2IG3tg_1794465656
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4902ce85f72so3021107f8f.2
        for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 22:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794465656; x=1795070456; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8vDJ3Ou7xzCxze/52XPwkTIU2JyVZ1LI+BGZWXtekYc=;
        b=ZtPfFQBcpCF6197DbyyHLCxXyaVxz/UY4xcVByKJ74+PW7vqdZZNX1Z1hLEUok9+xZ
         wnih+IBWhwWc/U1wNZYdnAYhsLDQw78ZsdaFXPNuB+MSXUJN3NhImiCuOBgYXPaIxqFf
         +LfhmRZW62+yI6InGwr7JNWhZHGgGIuf9DEqZ9doz61ssCiK9+BahMHs8rJn1HNrdcfR
         CfLuzCANLGo5LiGEW3rE7OitiigUkOAwWpED/2QgA1BAGGs85OqaU6LKhZPjoy2lg8tF
         XB8cPijK1cS4ZXfcH0iteD8Ccv3CwriOrVvH7sfq6yfW4wTZenmKfQsJ9LMcpTIoZVTV
         HD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794465656; x=1795070456;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8vDJ3Ou7xzCxze/52XPwkTIU2JyVZ1LI+BGZWXtekYc=;
        b=M0sOmMS0ZnLlhpFcVZ/rffh9bhPYtEG9GIIQSebLVJzffo5NqMRMb4pnM27qy+yLHN
         +uyPUEom/B9KHLYF1NAi0IxwLGTDZGMfg/GhvuUfcydkIWUQpwo6Xh0K1gXY0UepTRcT
         W/fVbrD+rYseDhNFTridrtT29XPZtWFXB4GaGeLt/AfJm24c/DX3LjuX8JpsnndX6CY1
         7Gpbv4Znj+xdc1JXIzl7wb6/ca5yuQZ30RgNbApU/72i3dBn6lBzg3X27hAdvobfrvgr
         xX6uXCDAJv8aibjqoWaiFt45vCAqiJKkCYvgE52QT943sGgp0v0TS79EXIQiaR6EEna/
         x2TA==
X-Forwarded-Encrypted: i=1; AL+hErFdV6sYy8Tj+KZSkhgLYQAXZfgBXcR+DGDk2wTlNYzAj076OUKZrD7cD8IACYHiq3Ao5PlYhAtB@vger.kernel.org
X-Gm-Message-State: APuU4Z+aYxIyXdHdTe4jW1apT/fskmn5RjKrgA/N1LtCRqlj1WLU6eS/
	xtaVUzWuPKisKrsgydMjHmi7Xly7MA1X+SykS2TNZPvOimhrBsBGf4aWeneknxs2/TfYLnGat8d
	ukwcZ9rWBjW4eSTmd3/xKvH04Ep2qbUmmvLHTjfaoKTo8aY1TvAAVCiAq1tU=
X-Gm-Gg: AYBFou2T5UUrzFxwTUs1MfaXHsdkrX5Thl+fv7Z7IJ4buuzTDZ4o++O+2GvNUtqGHla
	+y4kc/vowSkV1QpOiFxt+DxtzgA1O+MJFDuaoOFIbLBSczzTfSj7WSjjjVsGUBRXsnqFMeRXPq2
	YZPFF060W+Xe6RxdmBLLRak++45JhjNeheByvxHSeO/oFIrDr2Sv9gJcZU72ijjeHap6yrypEPv
	tDDEwf4vqtVEMilulnC2KMwdr00RK6lgWBH1N9N1Ym3D1R9bZ19tMlD8bizldbA8fDOcz6S4hlN
	yivYnpKF/FgMuwRhUe8ZtDtM/oGApmpCkc2rIQMP/baSFHOd/oefw9/1F/8t1ViDBKgS3MBzOQj
	5zQOfEZ8s+jJ7LpwxIEQ/YXJw+V2rKanpFNd/agMFKHv29f1HsUU8BHwESOEYs4YQ6bEiSM49tu
	00DqE=
X-Received: by 2002:a5d:6f16:0:b0:491:6b1b:7f25 with SMTP id ffacd0b85a97d-499c792ec97mr7218179f8f.45.1794465656004;
        Wed, 11 Nov 2026 22:40:56 -0800 (PST)
X-Received: by 2002:a5d:6f16:0:b0:491:6b1b:7f25 with SMTP id ffacd0b85a97d-499c792ec97mr7218131f8f.45.1794465655658;
        Wed, 11 Nov 2026 22:40:55 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49835d2bf91sm15226028f8f.23.2026.11.11.22.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 22:40:54 -0800 (PST)
Date: Thu, 12 Nov 2026 07:40:52 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org, tglx@kernel.org, will@kernel.org,
	boqun@kernel.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	kprateek.nayak@amd.com, luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org, longman@redhat.com,
	ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, shuah@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, parri.andrea@gmail.com,
	m.szyprowski@samsung.com, kayracizmeci@gmail.com,
	weihengqiuu@gmail.com, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v5 17/29] sched/deadline: Leave a dying task out of a
 rebuild of the accounting
Message-ID: <avVfdI8NRaLN0ZHH@jlelli-thinkpadt14gen4.remote.csb>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
 <20261108185406.1549770-18-mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108185406.1549770-18-mathieu.desnoyers@efficios.com>

Hello,

On 08/11/26 13:53, Mathieu Desnoyers wrote:
> A rebuild of the root domains' accounting takes the pi_lock of each
> deadline task, not its rq lock. A dying task past its 0-lag time
> releases its bandwidth at its last schedule. It holds its rq lock there,
> not its pi_lock. Then it clears dl_bw. The rebuild can find the task
> between the two steps.
> 
> In this diagram, T is a deadline task that exits on CPU 0 past its 0-lag
> time. bw is its dl_bw. CPU 1 rebuilds the accounting:
> 
>   CPU 0 (T)                                  CPU 1 (rebuild)
> 
>   do_task_dead(): TASK_DEAD, under pi_lock
>   __schedule(): T's rq lock taken
>     task_non_contending(T)
>       dl_task_release_bw(T)
>         total_bw -= bw
>         dl_bw_gen recorded
>         record cleared
>                                              dl_rebuild_rd_accounting()
>                                                dl_clear_root_domains()
>                                                  dl_bw_gen++
>                                                  total_bw reset
>                                                dl_add_task_root_domain(T)
>                                                  T's pi_lock taken
>                                                  dl_bw != 0, dl_bw_gen old
>                                                  total_bw += bw
>       __dl_clear_params(T): dl_bw = 0
> 
> dl_bw_gen does not help, since the release came before the rebuild. The
> rebuild would count a bandwidth that nothing releases again. The root
> domain would then refuse deadline tasks it has room for, until the next
> rebuild.
> 
> Fix this with the record of the bandwidth, dl_bw_cpu. The release
> clears it under dl_departed_lock, which the walk holds. So leave out a
> dead task with no record. A dead task with a record has not reached its
> last schedule. The walk counts it as a live task. That schedule then
> releases the bandwidth, or puts the task on the departed list. A dead
> task on the departed list keeps its bandwidth until its timer, and the
> rebuild counts it as before.
> 
> The Sashiko AI review of v2 of this series found this window. Its review
> of v4 found a gap in the first version of this fix. That version also
> left out a task between TASK_DEAD and its last schedule, with its 0-lag
> time ahead.
> 
> Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")

It's kind of minor, but I'm not sure the above Fixes is right. This
patch alone can't be applied to fix the referenced commit, it needs the
(at least 2?) preceeding patches.

> Cc: stable@vger.kernel.org
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---

Other than that,

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

