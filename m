Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AB737DEA4
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 20:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788296161; cv=pass; b=KpsN916swmUSzvprNBvB6xoR9C5rURhk7YrJo223gQoIyM1iRCg07dZamIZVwppnkun4RqFV7kq79ihpLjPZOwH9gWgmy8RlSNY7sxGZm629pkeRZV/e1yc5otm+iW1RF+ztAjMVRsQJcnGqWbdSVyg98vYZ3fHldQT71EHp64s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788296161; c=relaxed/simple;
	bh=ds0R7RSWqyOotBdAMyqdu/tBAQwZG7fw93dEWKgQL/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=js5YfbTnzJDc2TQl+wXiOA/SAv2HYK6nXxRGnwKxEa3HGR0RcUnDieQx6tq5AGIGaqx0wS0jxy1AKD0nY+Y/m3e08Ynn26f7g79DcS2sJ6a876+CV66wm1mtMYwxlBOPHfobb070YzwlvkLQ/kK3ejv1KqOGz4iOWoBFwEzgH+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=FcBGHHlR; arc=pass smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="FcBGHHlR"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d7200b2e15so2783015ad.3
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 13:55:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788296150; cv=none;
        d=google.com; s=arc-20260327;
        b=iZ9LLXJhWerV5c/c2Sk8JCxt9Je+5ZSy93ElcdC9YUWmEJKEEaDFlnyybap7/JW0BW
         RdlWnyOFXrEqSKzdJQRwNXxnZl77Fio/5oEGcjh2+PHl5hm3rwvq/eh9nK0h2UUYRNFb
         Dv0FAU2Gx81LrgrATXYazgl5XfxnWcekY6FJaig94e1zV9TSJUlRfaY8tnanViXFfGyL
         8AfutjsrqNSRT8PEIHbHzTPGjAti5hclFX9bP/zRORmLF9j01VzJI5XRXHPxv2+pQMbi
         v7eXgxkVZz9a+0uuYKd0nidCZYEXRXVaRyBc/wvsHAhF4ENEvMufbWjIdmHo0yts9rf3
         Jggw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ds0R7RSWqyOotBdAMyqdu/tBAQwZG7fw93dEWKgQL/U=;
        fh=7mQJ2xZwnHNpXxkUg3MlriWaxFGbEN2K5s3tDEuN6mU=;
        b=NKOnVjYVXK5sF3ls2O6Cqd6oYmkQETZdylH3fgpiL9R2LXUI1fp+CN+ELJI7ry4ahr
         y4JAul6D5Al1k3FX6C1sbLvaqei9FRhlSxl6l0spA6u7fupXoNHR+2dVDilOO1GhJfFw
         rg/SPi8DFEtTe/lTns1ncfUztl9MDGLYDKfTsN7V9W+izFgp5Rt3h2GvELgKZqWEg3Ii
         8RaT8bDwb4cpT5UwQ9F/LTDvv8+80Ug29sllTW2KLTcLfuj/yTYcLPALFoOaD+ucWOsr
         fxv0OYmXbkcqnExBFzWnfMfP00o2MBEHbirRwRTccZWzq2XcnUVMu4TRnREeTf6CcUkX
         WK1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1788296150; x=1788900950; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ds0R7RSWqyOotBdAMyqdu/tBAQwZG7fw93dEWKgQL/U=;
        b=FcBGHHlRa4KyK6GLEYePiV1yMfHY9X4tCxvXfbyyon/t4mMQ77vFLr3Efx2H4xoojX
         K5SAoChJLrfCBfofVkHLb5sE2bERbvgJYYddVya8hqWqdSuWaFGOyg9tIdxTI0qaFZpC
         47nCqGNHUg3csj6vtTSPbDwJ2zSKc/zSacqGjov8DXjDMpHZ7MeFO9JbSTPn6Uk6uSMI
         TSgnAXMVXQ09ZvX4z8RMrg8nwu6l4GY1UxI2q7tp5pYzwhhfAeaGXKTHKmuXLmC4GrLu
         0gqGrkEsSyv1x1om4rvM3kVHMnONK+hCLFGcmgksArwZQLerVSqrAloo3ZVLobxU89/L
         sC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788296150; x=1788900950;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ds0R7RSWqyOotBdAMyqdu/tBAQwZG7fw93dEWKgQL/U=;
        b=cUdKHDyaZnPTHSNiUFdIqPGFQkJdiJVQnc8vIibSYliB6SWbOhumA+8Jr1IXVJwmVz
         OHdwh24L1XeD2Q6WHGFtrBSKNz4uOxLJKTtGy//tfd1OR162kGL6Hg5Djt9dn4OE1lGE
         jPip0JAKrvvd2mwamAriFaHa5itRFjYFqn4qt1t+n6TCe1iL04zPfJA7sFxy/WURHMM6
         g+PlQXP4/o1Dt/oa90GsF5RXBiuH3fNC1kzXcfoT0E+QWqjARGo47PyEUot1gHuUQQ/7
         IP7QjAEmPmNCYmtoTbXIUxn0zxP9u5G102J03IlyHhR5UpwBCXplC7oVtmb21U5pipYQ
         Mm3w==
X-Forwarded-Encrypted: i=1; AKwUvBwdZdfyB0uxdg/40BbbGVV/+vajQyQfd3E1gAUZwLS7AquVYgMDdPtme634QVKGwqacclE+DQlG@vger.kernel.org
X-Gm-Message-State: AFuF++nYBD9I3H3E4IG2ijOPfxETA5CWt4zo6YznrqWqoXKGFiGlq6qC
	Sr7eLwkM/pcQNsr8XEfJWurY6/8Wh8YyO+F8BBIdJYDVVwxSUhUtZdpv9jL+YBxF5GSdzqM3Ncz
	LtVEVostA4nKD7CzKGmpDfHCKyUoRkzfITQJHUPrW
X-Gm-Gg: AYBFou3Y4+RMN33SX6HNAjxVeRuRnizRpVLA5RlopAjdazsRjzTBhTd2jqAKYxIJ3l7
	F4SiLBtm+r2lMh5vgaDG8y73Lfb2U+FVj/9bqxT25MjO72HzxDlqMhd/vWDMcsm+2xfAWNenRDn
	TMCh2al6FuynoCgxmjfqN/A3pBGthwvQULMx3FnUyuE+8zh2727CwDcSgvMXjz95CKNcwLLW9+7
	l8RM7tXzOYuozSodqR4zou+a+MRmmHl5qAr6YUd6yFWvu3xpgNq54VNSVJx2pBvqL6iN0qUK6yO
	GlNiman9hyynW/aorV7xbbrwcglysAX33qlYqak/8cu0hO+P7dTBmgFx1KV7FRgTUE555aCcrZg
	h8wqWgAXh+l9WMMaNsZWg5zskZ3gFLA==
X-Received: by 2002:a17:90b:3b41:b0:381:6c5:3f63 with SMTP id
 98e67ed59e1d1-39907cd4e1dmr14923888a91.6.1788296149094; Tue, 01 Sep 2026
 13:55:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828180322.730419-1-longman@redhat.com> <ba138f23-6972-44c8-8ce5-80de1f50891c@linux.dev>
 <85411b3f-bcbd-4a7e-99a5-49a465ca2df8@redhat.com>
In-Reply-To: <85411b3f-bcbd-4a7e-99a5-49a465ca2df8@redhat.com>
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Tue, 1 Sep 2026 13:55:36 -0700
X-Gm-Features: AcwNN1VD3djn7rU681MM0gPsbT7bDdd9EX-NdctA3Cep3e36lV4eXPZoh5Q-0g0
Message-ID: <CA+0ovCg3BcogTUuqZwboEaZW41dkcsAV3nWjENOHc5ZFGaEarA@mail.gmail.com>
Subject: Re: [PATCH] cgroup/cpuset: Handle cpu hotplug race in guarantee_active_cpus()
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000b98a53065a72242b"

--000000000000b98a53065a72242b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Apologies for the delay in response. Upon our run, the patched kernel
388b607d107c07aaade04c7f22f344cab6bdccd3 no longer panics when facing
the attached reproducer.

Thanks!

On Mon, Aug 31, 2026 at 5:09=E2=80=AFPM Waiman Long <longman@redhat.com> wr=
ote:
>
> On 8/30/26 9:50 PM, Ridong Chen wrote:
> >
> >
> > On 8/29/2026 2:03 AM, Waiman Long wrote:
> >> With commit 2125c0034c5d ("cgroup/cpuset: Make cpuset hotplug
> >> processing synchronous"), the cpuset hotplug operation becomes
> >> synchronous. That commit also removes the code that handles the race
> >> between cpuset_hotplug_work and cpu hotplug notifier with the assumpti=
on
> >> that race is now gone. Later commit 7a0aabd9ce69 ("cgroup/cpuset:
> >> Always use cpu_active_mask") updates the cpuset code to always use
> >> cpu_active_mask instead of cpu_ohline_mask in various places including
> >> guarantee_online_cpus() which is also renamed to guarantee_active_cpus=
()
> >> in that commit.
> >>
> >> In the case of CPU offline operation, cpuset_active_mask is updated
> >> first in sched_cpu_deactivate() to remove the offline CPU before
> >> cpuset_handle_hotplug() is called to update the effective_cpus of the
> >> affected cpusets. The cpu_online_mask is updated after that near the e=
nd
> >> of the offline operation to remove the offline CPU. As a result, the
> >> race
> >> comes back and the top cpuset may not have any active CPU leading to
> >> NULL
> >> pointer dereference during the race window when guarantee_active_cpus(=
)
> >> is called after cpu_active_mask is updated to remove the CPU to be tor=
n
> >> down but before cpuset_handle_hotplug() is able to properly update the
> >> effective_cpus of the top cpuset.
> >>
> >
> > Hi Longman,
> >
> > Thank you for the patch. I believe it should resolve the issue.
> > Could Farhad please verify whether it works as expected?
> >
> >> Fix this by adding back the NULL cs check to avoid this problem.
> >> However,
> >> the output of guarantee_active_cpus() will be unreliable during that
> >> race window.
> >>
> >
> > If guarantee_active_cpus() can return unreliable results during that
> > race window, should it instead return an error when it cannot
> > guarantee that the active CPUs are usable? Otherwise, callers might
> > use an incorrect 'pmask', which could lead to other issues downstream.
>
> I am thinking about that too. However, the change will be more extensive
> and it is that easy to figure out if we are the in the race window. So
> more thought will be needed before we can make that change. In the mean
> time, we have to fix the NULL pointer dereference and it has behaved
> like that before.
>
> Cheers,
> Longman
>

--000000000000b98a53065a72242b
Content-Type: application/octet-stream; name="reproducer.c"
Content-Disposition: attachment; filename="reproducer.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mtj4rdg80>
X-Attachment-Id: f_mtj4rdg80

LyoKICogUmVwcm9kdWNlciBmb3IgMTY2LWdlbmVyYWwtcHJvdGVjdGlvbi1mYXVsdC1pbi1jcHVz
ZXQtY3B1cy1hbGxvd2VkLgogKgogKiBCdWlsZDogZ2NjIC1wdGhyZWFkIC1zdGF0aWMgLU8wIC13
IC1vIHJlcHJvIHJlcHJvZHVjZXIuYwogKiBSdW46ICAgYXMgcm9vdCBpbiBhIGRpc3Bvc2FibGUg
Vk0uCiAqLwojZGVmaW5lIF9HTlVfU09VUkNFCiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8
cHRocmVhZC5oPgojaW5jbHVkZSA8c2NoZWQuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRl
IDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN5cy9zdGF0Lmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCiNk
ZWZpbmUgQ0cgIi9zeXMvZnMvY2dyb3VwIgoKc3RhdGljIHBpZF90IHZpY3RpbTsKCnN0YXRpYyB2
b2lkIHdyKGNvbnN0IGNoYXIgKnBhdGgsIGNvbnN0IGNoYXIgKnZhbCkKewoJaW50IGZkID0gb3Bl
bihwYXRoLCBPX1dST05MWSk7CgoJaWYgKGZkIDwgMCkKCQlyZXR1cm47Cgl3cml0ZShmZCwgdmFs
LCBzdHJsZW4odmFsKSk7CgljbG9zZShmZCk7Cn0KCnN0YXRpYyB2b2lkIGNnX3dyKGNvbnN0IGNo
YXIgKmdycCwgY29uc3QgY2hhciAqZmlsZSwgY29uc3QgY2hhciAqdmFsKQp7CgljaGFyIHBhdGhb
MTI4XTsKCglzbnByaW50ZihwYXRoLCBzaXplb2YocGF0aCksIENHICIvJXMvJXMiLCBncnAsIGZp
bGUpOwoJd3IocGF0aCwgdmFsKTsKfQoKc3RhdGljIHZvaWQgKmNwdTFfZmxhcCh2b2lkICp1bnVz
ZWQpCnsKCWZvciAoOzspIHsKCQl3cigiL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1MS9vbmxp
bmUiLCAiMCIpOwoJCXdyKCIvc3lzL2RldmljZXMvc3lzdGVtL2NwdS9jcHUxL29ubGluZSIsICIx
Iik7CgkJY2dfd3IoImhvbGRlciIsICJjcHVzZXQuY3B1cy5wYXJ0aXRpb24iLCAicm9vdCIpOwoJ
fQoJcmV0dXJuIE5VTEw7Cn0KCmludCBtYWluKHZvaWQpCnsKCWNoYXIgcGlkWzMyXTsKCWNwdV9z
ZXRfdCBjcHUwX29ubHk7CglwdGhyZWFkX3QgZmxhcHBlcjsKCgl3cihDRyAiL2Nncm91cC5zdWJ0
cmVlX2NvbnRyb2wiLCAiK2NwdXNldCIpOwoJbWtkaXIoQ0cgIi9ob2xkZXIiLCAwNzU1KTsKCgl2
aWN0aW0gPSBmb3JrKCk7CglpZiAoIXZpY3RpbSkgewoJCXBhdXNlKCk7CgkJX2V4aXQoMCk7Cgl9
CgoJY2dfd3IoImhvbGRlciIsICJjcHVzZXQuY3B1cyIsICIwIik7CgljZ193cigiaG9sZGVyIiwg
ImNwdXNldC5jcHVzLmV4Y2x1c2l2ZSIsICIwIik7CgljZ193cigiaG9sZGVyIiwgImNwdXNldC5j
cHVzLnBhcnRpdGlvbiIsICJyb290Iik7CgoJc25wcmludGYocGlkLCBzaXplb2YocGlkKSwgIiVk
IiwgZ2V0cGlkKCkpOwoJY2dfd3IoImhvbGRlciIsICJjZ3JvdXAucHJvY3MiLCBwaWQpOwoKCXB0
aHJlYWRfY3JlYXRlKCZmbGFwcGVyLCBOVUxMLCBjcHUxX2ZsYXAsIE5VTEwpOwoKCUNQVV9aRVJP
KCZjcHUwX29ubHkpOwoJQ1BVX1NFVCgwLCAmY3B1MF9vbmx5KTsKCWZvciAoOzspCgkJc2NoZWRf
c2V0YWZmaW5pdHkodmljdGltLCBzaXplb2YoY3B1MF9vbmx5KSwgJmNwdTBfb25seSk7CglyZXR1
cm4gMDsKfQo=
--000000000000b98a53065a72242b--
