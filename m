Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D32415B62
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 16:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789143108; cv=none; b=umo5SPySTBUBeAyXSEzWOxAyqiQPNRgFn/ZuobKeSBvxltQM3aEuRgHrCKQAYPfT6u7fox4tj+hpHQYKYnJ6wgB9WJqk2ebMzEI9JEpE1T5WyjIoX9I8G6pqeCQDPjiJQ6cgJuxijC534xwxnAZVgZNIlRRfJzOt06Cv3uot1hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789143108; c=relaxed/simple;
	bh=9KC+h19QeQ0ZAIjwroejZmCB0hItZuK8z4JXahZWHzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u4LRp76kBYwuPj58sNkoldgTLVgFrHlajNziIKjz3m75xIBqCxhf+CtA6VuCB3wO08x/pYxhScHMT9Ioc1/eg/8f4nPZGkeDZcuUiNW02gyo0sAC3Ows4Tr5Kh+UCKbFbdP3IfK4Omfy5Lz/NkKPQ6MMexHyFpU2+W6KDPMdpJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WuWkToDm; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WuWkToDm"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49e6697179cso3269065e9.1
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 09:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789143104; x=1789747904; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9KC+h19QeQ0ZAIjwroejZmCB0hItZuK8z4JXahZWHzE=;
        b=WuWkToDm+Tgtab3HmqyL+TuySviu3lJ2ykp/qRvVUOtqFHW4CebAqQT4V1hSa6u2LY
         5CreKmfv9iv9xPaWFnH0siWe77SEisvOO7oLGTNpwiWw81mfRQkdPAeRiq7LVKS2Ml07
         3aM/E0MvLtuhE0fgE6Yb7ondVR83+QLgHqUzbFFcVIyJiBSRP6Ky5Jc6fEOzQQ+0FsbQ
         JW4/P33Cp02I32IRRHuTNPqy24pcHkLmF3KtlTwRL1whTwc5vaQ+9m1Kgldox2aEzMNH
         dIVP36VA4Q7bowUDCuXVLeSw5f6qiBtvGWdrEpFFL+SvCeoj4q4gVaH5Q2+WQx4gcywV
         VgOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789143104; x=1789747904;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9KC+h19QeQ0ZAIjwroejZmCB0hItZuK8z4JXahZWHzE=;
        b=aBZq/5r0iZqifbjbajgKXYkQM0z1Hl4qjH+q8hyDtOsUXfRyc7M/mXJy11e+xHXF2d
         MCyOJQ76EFpuIynVqRUA8+95pAaaL6mwj9o3gaK9gNVCS5XNF6sQl03cq7MWfTR4p6xx
         hCYxRekwq0i6Cpp/Se3sRNQEx5tZUOs0gXSDvp0eeV7QYoutDEICHWXRW7/nDIMc4F4B
         MDTnpxk/FJzi9Gn7fApFYGA9zgSPJVm6lMWhA0N8zJGwVXYIT8Nz3PZ3qUmVzv8buJEb
         KFXku9wn66boluuXAgEL3ZDA9NOYd3V6X86pRTVnAadUuznSxPbuYg/EUKWHLBzf3RhJ
         oqCQ==
X-Forwarded-Encrypted: i=1; AKwUvBxK86cfJxVCxwTc889JiONB8tFyxXgSmKzONYIxessz56jLbWx0swjjrGdp7IFLmTYqoyFdrzF7@vger.kernel.org
X-Gm-Message-State: AFuF++mW6wpVaIc3J3cPDCt6LsNjX7skrlxoEpNWffOCzsq5ESvMSU7K
	1f5hgpOiUJIIsb3XvsWdh4s4ZSKFM1SFa6kE+te1ogQwOpKR9ag3HF3xgTt+MA20Ug4=
X-Gm-Gg: AYBFou1NjI2aPLQUX/7T1C6mKQWpG7pB5IleMFtU7IvNKzQLYJgMtnhvztRq6WLyCDL
	BIkpkpQmBzS0FojmGg3ZYkueomfjOfLq3wZKRLFEB5mdI8OSR95o0i47Zs88Kmq2qdyuRzW7nqT
	rQi0L+DTNCkNWVMXo0mu4W1kJd9MTJz7nEU9vj4NE+R8KZOJ8/lzhPxLSEJYRZUPnYhrEUAvLE+
	BpzyMNo3h1gdFC4O2/VSEi6AlSRG6zCn9ayBINuOEVPXCQU2NzOEQloC4wCL125yHfXLxhMX+wZ
	X1tgdcEqDKb8o3tk5LIOsqAVjkN3PnxzR+UeLCftlHIz1rKBw45t9qzASVCqhxTNUlRRAnu9zAT
	1ldWo9Bqe6bwpRCjRV0NRM1e8Nnr6NE53k3oDoswLJMglRMUMIW02qQ5YPQLwlRzxa+K2HUu0TE
	2XRJp8rnooxyQu7hSS9dZ1MC6EDX4v64I6TkKLJs8IV/HtInH8z3C9qXPIU/9lqjrexhL+wjKx9
	A==
X-Received: by 2002:a05:600c:45d5:b0:49c:fa20:cbfc with SMTP id 5b1f17b1804b1-49e619c18c1mr59656705e9.19.1789143104418;
        Fri, 11 Sep 2026 09:11:44 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c1bc5fsm159143865e9.3.2026.09.11.09.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 09:11:44 -0700 (PDT)
Date: Fri, 11 Sep 2026 18:11:42 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Noah Feldt <noah@feldt.systems>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, N.Feldt@mittwald.de, carnil@debian.org, dschatzberg@meta.com, 
	hannes@cmpxchg.org, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] cgroup: Avoid iteration of dying tasks with zero
 refcount
Message-ID: <aqQlowpkYrTaVmid@localhost.localdomain>
References: <20260907192723.72167-1-noah@feldt.systems>
 <aqAtv3WVn51LN3E8@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vqaqn3dazvpkwhgu"
Content-Disposition: inline
In-Reply-To: <aqAtv3WVn51LN3E8@localhost.localdomain>


--vqaqn3dazvpkwhgu
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] cgroup: Avoid iteration of dying tasks with zero
 refcount
MIME-Version: 1.0

On Tue, Sep 08, 2026 at 05:55:45PM +0200, Michal Koutn=FD <mkoutny@suse.com=
> wrote:
> Though, the fix loses a bit of elegance. Hm, thinking...

So, it occurs to me that the ->live based predicate from v2 might break
CSS_TASK_ITER_WITH_DEAD callers (zombies they asked for would be
skipped).
We need to distinguish between (both on dying_tasks list):
- regular zombies waiting to be reaped and
- RCU remnant tasks that are going to be free'd.
IIUC these two are split on the ->usage count. (Correct me if I'm
wrong.)

I'm starting to like the tryget_task_struct() approach from v1 again.

Michal

--vqaqn3dazvpkwhgu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaqQoOhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ai4DQEAgpiBFl5EmgRYQ2x8tv4Y
gyHzyg0fU1nthPmlt+skLTkA/0HFH/C6Bws9kXraWbS2BO4rZ6+N2FJFygphH/o9
QkYI
=7ubW
-----END PGP SIGNATURE-----

--vqaqn3dazvpkwhgu--
