Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558004;
	b=tPlkKmy7hD4DjxFUAGv61ABkZccotsHInQ4Ev8IRO+EWopTEj4ZZHYwdaM8ZKjyprKAZ
	 pbUZ7XQ1CtkUrY9tMYP+w1Iv97kXeCKuTiQXZ5BaAnAROeAQqpTLh9nxB5VOMqLkpAs68
	 ormaNZdCVZ+YE9c0Cx7kFzn5vOcYZP5f1ocy1y9nrdisrG+mYLjavCRb+zSm+Uj1e0cyO
	 MAlGK9rH3OWGjJ8Q8fR3JSBTJYB2F8MY6GlXYkDo6DAxvJig/Ah1+UdPtrChKF58Fw5R2
	 JH8YDGO2MbtaK950XpaUe/5IUyYYOdPeaYluI5907eoglcGPQs3Xx8TAr1Ei9NBFecw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558004;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=u6ODy5SnsRQugFSPY6vBQTFSWdeeo67enpuBFMw2vTA=;
	b=u4blzPmGDy7I25PqQ3WNUnuqKxKQOQJo717wp0L63ED8R34VPNrFuRxmwnwXGGX7SjWW
	 RneJtVXtm16PRZ4vDSFcxTHzVdjFk48uQ2JmQa5eb7uDK+l7JaxZXs902MZkWM8Sw00Qq
	 pSGviFJqrbwURv44vBCfDOB1AT42W6Yry2ylibFxxL9ZJlTSsJ5NdB54iidv46+/wuKpN
	 lzkoz3HxNB+q5sYP5rZaH3rXLg5Tx1k47DLTDF0zzwCYTUWB+T6RhVzNXXyJXzyM3rtRY
	 5M2XnpEa45ByR6Q3la2aEn5kknP3rJqo0Blg+3OJHfyYwD5cAWm82RHPdyxTAbT5Zag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=OGJEvOtU;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A722D606A890
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 08:20:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A722D606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=OGJEvOtU
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-490585eddfcso614898f8f.0
        for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 00:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794558002; x=1795162802; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u6ODy5SnsRQugFSPY6vBQTFSWdeeo67enpuBFMw2vTA=;
        b=OGJEvOtUEBShLexZaoNIEU0Kv8IFFc6MSOKErs9nl6AT7R1oYdts6gSObwQu4spiUg
         PuagTz6s+qgS6+pEfJDcBUMrEB+UeARXCPje500BpFu8z+SnfHkrdQY32QSPeimCrmIK
         fBfyenwoh3fJtWsIrVT+kDdKV2r8W9RBtqTq2mwmiI9x4dXCZ2xC9ZQVvFuNQXwjs2Mc
         dMMrYCaybPmLrMqxK3OOBmq9ZiN0q/NxNUz4Lw+et1VWbWIP1NTBbD1fohcIk+XdNpYR
         NXcP2JhODHgUbxvu55f6+W4qbduZASDMaMUrYHPw7Ykr5syj6G54Gmf1Gof1Pmwzphuc
         7lPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794558002; x=1795162802;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u6ODy5SnsRQugFSPY6vBQTFSWdeeo67enpuBFMw2vTA=;
        b=Hvur6/0oL/C8K+7xkpNtWVV7oc2nP7A5ax7WwQo8MoabsaEf+dW0K6Vmh5dqN3NDEN
         Eq4/w2ckoY1QvStWz+v9kncgHYf30yabsBgYMF7Y5pgv1HFLIBjwtF0Gk4qrZh/ONEqg
         e7nTrDVouuQ95nCySuXnMh3Oi2NoA2FhtjJDodS7OOjegXdAOKiV2hictoqxXFGdzfz9
         vPUwafzo2y/PCYvjg8w+z7OS6gTMjHq0Mn+3LsEHSMBUR2qBrfhNuWWuExeLzG5GGJ9+
         zSzJJJN/jfViJXQzXbi2Iq3kTkiLKPJWQmz8mV8lJTxDobJqjhe14SEgSPB0l5GKIEOt
         6riQ==
X-Forwarded-Encrypted: i=1; AL+hErFrYPrB9rrBewX/PfZYJs9T358F+f/xxTjJKkal72xIMmwMl90ao1ZZ9+n+uMmfGOTqcDRdFkK1@vger.kernel.org
X-Gm-Message-State: APuU4Z8PFx1G3rLLQj4Up6A60pfkClw/xAQBvBWY5r4feA8m9KyQsU4J
	4p8mL3PNpAD/J2RVbNnnSXPGUUGoj+Z5ZNB4k0zU6/T2cwx6VsTyRuYbqexYXZaDFYI=
X-Gm-Gg: AYBFou2mNI6u91aoVv6i8j86gsBm98JzU7Zkos4IXEq6z6rGxSiHZYEa/jHeqkPqKsS
	GzT8tz9uODqRsmYLuG9Rw3KNasz2eY+PpV+VQ+/suWOD1M62Qbw2vtk3yz4UxoHHcnDU/ODEKbh
	LC0CIy8iSRcji2IdjSKgyre3m9mTPYOwGGoQxnaV89jnvAWjE9wLknMNZVj4JiG6jvmjp0yskW/
	N6SsNi2SaN7JfsHDvSJY+HiLN87P/DeA2CrWShEJxn66dndgc7yse8RcIlA0tXmg5okgt8BX8eb
	GVy/Lw1d4LOze6SAl77/z9imDkKMPvmoeryY2r4rOVk+uwbgK4DrHRRw49zl4TqY1NyJknf1jER
	gCrB5k2vD0SfmEPKr0DQrAq6hmfCWJenydR74S6+j8aqbS5gGmR81kyzjs4C06+GhfdzRO6ZmE6
	Kt6zNybTfLDb4mDAVAgbBF5UkffTqrjz1NsIc5bteqBHM0F9S6EOGT8KnIetLbVGz44wQMf1MiJ
	L1noFoHXFv+3MQzWSGmXRuowDhAqc6fvmB34lXlO1BLQVtQq7sHjVetJ2ad/cBZAeZja8RoNaZ3
	xblw4tV55hJiDIBTEGnoNHrmwGwXooawtR5kyCPkPZk=
X-Received: by 2002:a5d:5d86:0:b0:48e:43a:1d84 with SMTP id ffacd0b85a97d-49c712ac267mr3929586f8f.23.1794558002001;
        Fri, 13 Nov 2026 00:20:02 -0800 (PST)
Received: from localhost (109-81-94-245.rct.o2.cz. [109.81.94.245])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c609c602dsm3640220f8f.46.2026.11.13.00.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:20:00 -0800 (PST)
Date: Fri, 13 Nov 2026 09:19:59 +0100
From: Michal Hocko <mhocko@suse.com>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp, tj@kernel.org, mkoutny@suse.com,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
Message-ID: <avbIL86R61Lu2YVF@tiehlicka>
References: <auhiGqKJeukk7t3P@tiehlicka>
 <20261102114029.1259655-1-zhanxusheng1024@gmail.com>
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
In-Reply-To: <20261102114029.1259655-1-zhanxusheng1024@gmail.com>

On Mon 02-11-26 19:40:29, Zhan Xusheng wrote:
> Hi Michal,
> 
> This is v1. v2 [1] reworked the check, but your questions apply to
> both.
> 
> On Mon, Nov 02, 2026 at 11:12:42AM +0100, Michal Hocko wrote:
> > Is this a desirable/intended behavior? Shouldn't we move the dead leader
> > along with the rest?
> 
> Userspace sees it too. After writing the PID of such a process to
> dst/cgroup.procs:
> 
>   src: cgroup.procs = 85       cgroup.threads = (empty)
>   dst: cgroup.procs = (empty)  cgroup.threads = 86 87
> 
> Moving the leader would fix that, and memcg would then need no change,
> as the PROCS walk already returns a dying leader with live threads.
> The catch is that the leader has already gone through
> cgroup_task_dead() and is still accounted by controllers: pids, for
> one, uncharges it through task_css() when it is reaped, so the move
> would also have to transfer its pids charge. Tejun, would that be
> acceptable in the core?

Do we have any conclusion on this?

[...]

> [1] https://lore.kernel.org/all/20261027144016.2582880-1-zhanxusheng1024@gmail.com/
> 
> Thanks,
> Zhan Xusheng

-- 
Michal Hocko
SUSE Labs
