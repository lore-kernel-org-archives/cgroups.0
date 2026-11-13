Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590606;
	b=kve0bsojV/xewvMvyFCaLo3EmEWRrPCTpFEizsOMD/C0Q3hJo2Tf5U5QR1vOz0gCVBNf
	 fuiOcy265IAQ8NUiDYdebhDJSMNBrBmf0Qy6iJPZs04XyRjkoOfN0wUGM4/igkjoMxube
	 3c9awGCgGT1DepCXzc4xHjtCtuG1eqeI5HC4cIFKNuSCjjhUQPjJilZyHlr2CfbCBHNnM
	 gcPJFByGT/matWtt6gLcLr6t4hS/ddc64GX8oVDcrSU717dTmAVKpCvUeF8DjwkPbx7/E
	 +o6eMaYiOV1S7ufMSSP2E4/8bMeKlAmlwSLXWI3FxDCP9uWsIC2JAgrC3pa4bSow2QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590606;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=yu5QMzc3QXUklBl5GRmDPmTAJYce2ooMnlaR9b715Do=;
	b=iuOE/4XI24RyMrdHVZdB3M1rkMDIZu97kxGeo1jDBrAYti9BhZdNYk6LRcq/ukvUBaz+
	 BxrVJ1S2kaWZeI0BfjRZ6YbX6jeb4t949ej94F540UBfjCP+nsa72baYJsO9FHojd56mC
	 eDhDYrSfuwzweovrU17K00z1k/wN1cKzSF6SpdDauG6Qbs4+afEGNKwo9U0Cvaig1V9rw
	 YPA+D34d62VvV8/TQsZBxo+u3bF6/yi7fPq/p+KYIzxv1B+AHvMFkN0AZwI9jov0MOt6+
	 Wzr5G5qreWIpNpeQOuyxKb3FkE9aBmfGcYrZtQW4gmmDx/NaNVeli5p01PolfLkH1OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b="xkc+l/Ri";
	arc=none smtp.remote-ip=209.85.214.177
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96726075E06
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 17:23:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B96726075E06
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=xkc+l/Ri
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ede7cb02daso16932375ad.1
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 09:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794590605; x=1795195405; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yu5QMzc3QXUklBl5GRmDPmTAJYce2ooMnlaR9b715Do=;
        b=xkc+l/Ric1gBL/XJaF/g07pdXD3EjnqX30zCqgLh5dnb/W3Y3Q9ZzcPLGVnPIEW8I5
         i6wkzU4MylRS147v7U//alMndB9TXpOJXn0KrJJ/w0VKZJ/QDLctzKQtDx2FUPMqQGe9
         f89nfb9NApy3X0lORFb/a89MIDaaSpv1Mp310=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794590605; x=1795195405;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yu5QMzc3QXUklBl5GRmDPmTAJYce2ooMnlaR9b715Do=;
        b=dIjuZk9lqqwQhHRnnn6cxWUfWtAKNbDgeYPm5RwoH9Lw8p8HfW5CvdPFPNCyw0JiXL
         W6uM3OvyE9KpbaOSe4ImtdvzwmKlCLPMgYttbuZQ4N9/kD/dWFrkMq+Riq+BFwrGdrxH
         0axWyxZwUeK7YXHZnk5Y2ru8zSnY+buDrpdmOL4s6lyGw6Q9DNCYhwhR4pgkf0Vaz6NY
         pdZbt5C985wS9Zgcim3z0BhuPo7mvSlR9xPfPy1yzpa6fsXPsmpliHtiOF5GTqeAixnO
         znWEqVy6YpnDgPsbh4tv6826eWnK0YM/6xURVm6hAlSRI9V68+017fasvvCEeGMm4XIy
         EvAQ==
X-Forwarded-Encrypted: i=1; AL+hErH1LuHJFGjtwircT31SXFxxdXKs5OftGkpiWOALqdhNQU/aQm6Dz5kxDUpijxsavHJKbsVJyAfO@vger.kernel.org
X-Gm-Message-State: APuU4Z9x+p/fIBf6TWd57r5AyUiYtjwR70IMTxoydqY6lTo7KRNed8JC
	pytBvuVRFrE8txW2IEZ8PhkRIckiLeftFx2HbToEBlKAKAqM3NCUMqJE8tgHL5S9U7c=
X-Gm-Gg: AYBFou1gt66ja4MNvJiiUL2m1OKCEfcObgyRQwPIhQaR27kqa9Ocv96jH8VzunHrTcD
	o3ymJuv8KLsyuXBTVsehFCxvaJBgahU5HJAz98fH5M0cwUtS2jljDNYoyilkczR+2sYzmp8vSJ5
	IoWjJ3AFdCeAxg3v9ohuu+nY1Q21fM7688zMm7U1Tls1q3+lOON7HJPeVMpGnd4X5fC6Wfx52cM
	wyMuZaHuf+8lIfrUMeCxyyL5clzB1Bbdv3AlG1lYrd58tRvcIbalzIbOF02rKSFBE7OJmwiVone
	zrbFrVPDx7dGDJOPIQ5JMv38yos8MFoLPC4tuZS4ipCmGQHkuhAR/DU1IplJB62ITlu8uFX7WN/
	ChYpth4z51qbQc2liXVefSpCKoV9fzSWa8AeLOZZvd0brAySre4/ZqQYfat9lVDaqUMnsuspQ25
	8Eu4vQZkUVGNOOWOfgP0J3mUj7W7sFdjHTG9g3L/ZWJjma2M0EVN+b7EdkevLxqPo0tFGSiusLW
	1hMqMYrwXvZce/2uzVSOmrx+Ej6o4RwMz+p0M/whShRILaMzGtl7pyXcgfMQBgpvyFQs8hGDZGa
	PE28HyMKBVaDz1aWNxf58gpCE4P/1azXi+E6P7Al6JaEH9x2Q/rL73p/8M9zfMlokmDk8KxUxkB
	otPFxNpcVwumuiv4pGr1rUei/q5P1B7daH454s/xmPDtVn7mQ6+1FxC/G/7IvGbVhULeqOaQjCU
	baDGckPNP2d4m04YtOA4hcISBOkVP4giL0N9ugikzihIi3Up/utq4XJ9tW0IM=
X-Received: by 2002:a17:90a:c88b:b0:3ac:a6a5:5757 with SMTP id 98e67ed59e1d1-3b1b0b5beadmr2012590a91.11.1794590605026;
        Fri, 13 Nov 2026 09:23:25 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1ae98151dsm5319144a91.2.2026.11.13.09.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 09:23:24 -0800 (PST)
Date: Fri, 13 Nov 2026 09:23:19 -0800
From: Chris Down <chris@chrisdown.name>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Julian Sun <sunjunchao@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 4/4] writeback: report a slow writeback wait once per timeout
In-Reply-To: <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org> <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113092319.f975912d92c98651@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Breno,

Breno Leitao writes:
>The flusher only checks for progress between inodes, so the wakeups now
>land on the first inode boundary past the timeout, a bit more than a
>timeout apart. The hung task detector scans once per timeout, so it can
>catch the waiter between two wakeups.

This does happen in practice. With your null_blk setup and the timeout at
5 seconds, the waiter gets woken every 5.0 to 6.1 seconds. khungtaskd
reported sync as "blocked for more than 5 seconds" in one of five 40
second syncs with the default check interval, and twice in a single sync
with hung_task_check_interval_secs=1. With hung_task_panic set, that
panics a machine whose writeback is making progress. Stopping these
warnings is what 1888635532fb ("writeback: Wake up waiting tasks when
finishing the writeback of a chunk.") was for, so as Jan said, the wakeups
have to stay below the timeout.

>-	done->progress_stamp = jiffies;
>-	if (left && timeout && (waited_secs > timeout))
>+	if (left && timeout &&
>+	    time_after(jiffies, done->progress_stamp + timeout * HZ))

But this check can't stay as it is once that's done. progress_stamp is
reset on every wakeup, so if the flusher wakes the waiter every half
timeout, this is only true when a single inode holds up the flusher for
more than the other half. With the threshold in writeback_sb_inodes() put
back to timeout / 2 and the rest of this patch kept, the same test prints
no "has been waiting" reports at all, only the "waited N seconds" line
from patch 3. Going by the code, three quarters of the timeout would
mostly have the same problem.

The report_stamp you had in v1 keeps the reports apart without touching
the wakeups, so maybe go back to that and leave writeback_sb_inodes()
alone? That also gets rid of the duplicate from wait_event() checking
twice. With v1's report_stamp on top of patches 1-3, I get one report per
timeout and no hung task warnings.

Thanks!

Chris
