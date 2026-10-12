Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F60047255A
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 14:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814103; cv=pass; b=ipQWSHLH9Q4ojbbm48iedzAMz7hLAX4VIoOpEHxnzw57oxEmJrCGk1n4oa7jNKsjLnvrM+Ej3dyYJD2BF8Q2eDLB1FR6AhBq7j3ccmAWou+bWmmUKyUyLGa0dAtGjHIXzrfpEKElcJlu969uXlxMaFDO3uvapJqy6saehd/KC30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814103; c=relaxed/simple;
	bh=Ds1RsGrXdYNa+VIUsNtvM0HHuJhu03SNmjfL4ZgCOaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ci25Mbr4VgKIP/Xh/LiCdq5f38dvjqPwhNr1H7Mb9sxL0BleXHdpbTJrul/ZmYtfEP04szUoptZjjwnVALRKRXYcnr4QyKt8AzGMiSX8XEOBYeBoX4Di/zO2+ekOABZRvaOy+bfAZokoqRMVUi8YrWkdBWgS4RUuwHCe4+Rc86I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ectYOyZq; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ectYOyZq"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-53584e7c349so389761cf.1
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 07:08:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791814101; cv=none;
        d=google.com; s=arc-20260327;
        b=QxSTbyThRfpECxXbLrOlhhvdelpNqktgrD20Eu1szlZOPhumFn0fKWlrsXG8tX7fBK
         oQhkeM0ogwSFfTpSY1lpcTNpm/hyvJNIxIZ0mc2zXUQEVzzPK38Re1vbjZrPVtFly0qH
         m8Z5gIWfOLuD44KTAOXwcCjJBxMQZHTF4ttdzVMn9EOj0KW2KdLlnPOR1lsm77e/0aYW
         JzZJTuCRqx5U4u6QWdJZabrGw5HYkLpUPkIoub6rbaukg67DYGXK3tCy17hNSRR4L9aY
         ia2uifCdF4Sd3yCRk0TfYkmm5V/AUgxzz0lL6M+hM1aZFbMbFLVBk3eyjCjw6QarsCPV
         Fnww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ds1RsGrXdYNa+VIUsNtvM0HHuJhu03SNmjfL4ZgCOaA=;
        fh=bYL+/VKdCesQW6/o5pFS40U/rKf33Y7talk9ioTeDSs=;
        b=gvcEF1UghN9Y+M3fVy5COHYxDgDnc5moiQ39VXVHnu2AbP3zzUBOyGHdd14Vo9/+5S
         Bj4mZTwAKe6iJTF/eIsHKBPtwrZybhSJdDAiaz0dK6lvfZLc+231idiWSNa03kZkbhMX
         p9NM7meOzWaVYsinGdR/GLd6oGeQw2DMcfbnsIeT2i9lHhpC+he+lOj9M6WueOE7pg5v
         j+7r5RqJEJAe/vtbzQaVVSDDVuSLxIKDI7Eq17e6y20QW8XVweG5J7m7kR/3pcfN1DZN
         b9ZQh/4dSyA/qs7hTYKcVq1VvnrRdRs0zaD6OT8955VfAnYEk4BhkDSpXzwmQKk4ljpb
         aDnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791814101; x=1792418901; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ds1RsGrXdYNa+VIUsNtvM0HHuJhu03SNmjfL4ZgCOaA=;
        b=ectYOyZqOs7o1BAwfNu0XtZqS0hRHkIgsvj15HV5N8YwtEWF0wHD3CgSD2twRw4hpP
         r+V1jWidXi4x9J0zA2SQzpEIZ9c3N8lSZ70liF6ohI3zX9zpy/G3CP9rSBgxN/NmtSdL
         SzzLwXNIQRSytMj72J509IPvn89qVtJk4I7ZDNoqHrx5M4gCbjJsNWwvifV+EKdhLEP4
         QdszS1y8kmWlu5rRfgupNDB9gDKx3LKRNHB4ZY8iGQIqF3M1QNPpPM+wfFiFQ1N6FKpF
         ThrxQ424vKvqWpCAoRGI46GGIInHpd7nkSZtnYWw0ijUACQODILBWc1vd23KVDbqztHn
         Kk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791814101; x=1792418901;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ds1RsGrXdYNa+VIUsNtvM0HHuJhu03SNmjfL4ZgCOaA=;
        b=N54QeEFVwE2TcxlAEeopSUpD6pUAl9WiylUnvSsEDixUmNzl1NHIGhqkKGbhQyEbo3
         22RPkLW8mX1J9x2ieNGiAT42xEMi5iSpoq93qsdL5SfE9Pu+Pvsp+yzH6qf832Z8UYfC
         nC7+xbsD7WEXZ6b0oVIGL+Sewka2WyZM0agl5UuDRPqHGR3mc6Jln876M/7LVPzVSWgA
         LjnWdFJfp1k+X/n0mXHB7wfKRfIh+66WMBOmSZ8c5h3CqC8rWGTChcM+TOvd22PDIUw1
         mUmqXLLcdzY33Kmv14JFsDqVHHqUegwkQ98ZAfLCdoOipOoGpR7Otmqjvzy2BVQVr2yJ
         q4CA==
X-Forwarded-Encrypted: i=1; AKwUvBySYXV0BqS4EJpIdYwWEzHmS92uRgQ4/90I/GBYjanroVdQdDf8CBvJFjAVfMkm0Kqz1yftcfML@vger.kernel.org
X-Gm-Message-State: AFq9FYKg1xKe4f7plJ11+n3NKFg0CbpdkSTFQmfGztxo18vztWMrG6Rc
	4qvP6cy6zc8vK7Gpp3RHlHIsg7FDMnm2q7MwXgVAOOZnzH7zNuS1BwPzPBwOclPRy7qXcvG3xDu
	OxlgeTYeN/M829BWXFDCjQKnc2Gfq7uu/uo+e96b6
X-Gm-Gg: AYBFou3paR02to+pTo91udOen39tOCm/jSi6tqluF1L2+4cSMoGifUZE+2swGwgeRIV
	udFHgJwDwoWF98mNJrSKIlJjsLZ/vBHS+nhKOUJguTBNbSk4wmV3Cik2d8rZm8jLfL/E2lRyO3a
	BUzk6YgKrgXoNYQQK6LHAKHreG1OS0loa482mMn25zwgpPbdRKpZ3fr41k5+zvY/xbNspjXQMN3
	EcLopkCyJ0fEOZ8Nc01RIN22Ho+Rx5QbTU47OUnufWNS51c5g0K5IFwsUU+vqRWJ+TboiT+kiBI
	VaMaH1NW7ZEEmyxNNhVvnj1f2Lq/nHfFN7di5IM7C1isqQRQbALc4y09CBpO0LUrFIF2LyxooLZ
	prvINWZP4tEA=
X-Received: by 2002:a05:622a:413:b0:533:9746:9a86 with SMTP id
 d75a77b69052e-535b325f8d9mr32241681cf.5.1791814096393; Mon, 12 Oct 2026
 07:08:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261011223358.2327625-10-sashal@kernel.org>
In-Reply-To: <20261011223358.2327625-10-sashal@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 12 Oct 2026 07:08:02 -0700
X-Gm-Features: AclHuK84WqMsyxy-I57pRe8rAHj6B83pUNBHs476hJrJgTGppN2WMc_WLWeA8KM
Message-ID: <CABdmKX2D1obDASTm+exAtrZSfkLikUxmzKxjsj8avyfUbEcsFg@mail.gmail.com>
Subject: Re: [PATCH] selftests/cgroup: free the paths returned by cg_control()
To: Sasha Levin <sashal@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Amir Goldstein <amir73il@gmail.com>, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2026 at 3:34=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> cg_control() returns a path allocated with malloc(). The two callers
> that pass it straight to inotify_add_watch() never free it, and pass
> NULL to it if the allocation fails.
>
> Keep the path in a local variable, check it, and free it when done.
>
> Fixes: 5313bfe425c8a ("kselftests: cgroup: add freezer controller self-te=
sts")
> Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and=
 IN_IGNORED")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>
