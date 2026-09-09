Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD82F582B9E
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 16:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788971530; cv=pass; b=dD/W1bIV/trj//aXi/Qcdz5tSZaRpTD5RAL4Znqe2rdGviv82DKo6mOdssCdJZKa6Nazplz1S5hRjNdQnKEVZDrP47dUU+7jAiHrRqocrGXobhyrJ75BYYUm/tyJKvjyHV3XjIj/vbu3OpDGzeO3Xw//HI6j8QPF9MgED5PEfjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788971530; c=relaxed/simple;
	bh=r44vAOmSHOyOvNc7T/11Q08h5EqMSZopzIEzum1UHI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PIVEO+WQIkLYY/1+l/9v458MAjpSJPkeq9Ezq3tLVBbavbWpfjnJwH+qiy3v7J0EhlFSt5s67/YngVVekr8rIMuTv2T4VPlGy4ahLUllIH+K904TwjlKl/oH136Ul7wsJP6kkYSoVKnyMoTAreKvADesRO9enLf8AOnW7nIDhCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=tqGXfepl; arc=pass smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="tqGXfepl"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d58efc7356so78233165ad.1
        for <cgroups@vger.kernel.org>; Wed, 09 Sep 2026 09:32:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788971528; cv=none;
        d=google.com; s=arc-20260327;
        b=rPXYRbCSL4sTd/Vjh3qSnQopdZjTkhYrRQdvgPLFQehJioQLSbaA8x2sYYsZ3zq85L
         2eswIg/2ecQ1PFaJ9BYNyI6ufHrBQsmiplYILJE3/hloA7jx8SaaGV/u4jVxPvnrl4ov
         jhcoefjLwQnOl/6/eGR7BpGBAKoHhJSTv3DWNW/VNmnkub2i21tuDCF5JU4JatL+V+3w
         uk5TM4EZI9sUB3WT9bKNZQ1QXMgZUJGWfSwr4jt6UampHZZE2QVfHANKbNEK+r8BwApN
         VR/KRBp1GDoZwKUGPOG052XC9dqoBJXyKukknueGsB0HP+VMJCqW2SBLuhcQvSjqopRT
         6ccQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LbwUECXSGtpoNpkapF0wkYICgxlHh/DhMmXXNw+XPjo=;
        fh=0Imnl2zAXp3DyRvGfs6fPNqSp0sJV2PFFGZceyDNipg=;
        b=sjzerOUDPVxImwLr8ALXcNMWWUbMH/grfgoYAuMak72t4paMUcqzYDtCsy3eGn5G7m
         OGVi9AW/JrdZSiWiav7m5PIKspnzi9lcbFU98YaGYxk//B1afZjlstmkq0ErOLFQbeCU
         uukwgNcig8gHOoSS6Ny0O0NQwp/bmHocZ00rIu2VQDbatzvM1wVoaLnSKgDcyHVCXv49
         nbRIgnacb5nTgmSmlD9Ma7AGkutJmUmgAjpjQD7axxzXMjoMr4l7LeFwHsFJW4Wn13qA
         a6cdQO3ZU5DmCide03wA6Py2dKA2S2NhiML/0kvqawrh/jq2Y+2GMSUrOjsAT/EJHUJY
         Yv3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1788971528; x=1789576328; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LbwUECXSGtpoNpkapF0wkYICgxlHh/DhMmXXNw+XPjo=;
        b=tqGXfeplKXANc1BlHoP9KIRN2gR2Mru1D8TVLe/oWChEyvb3L1aRML9+30MiZmoz+C
         qCqF/+j2dYltqVIqhHGO6qHsNAu5IpuepMkvpwuSDeCRlcxvSjU7Yxk6dmHRXHax6C3j
         GJHYPrv2wD1VpE3iBF374ZbNr3ZP1Ok0PbyWCvG8Ocog4Mp7dWHQeYCQa7wSsm2uqT3s
         +cPJjan8RSuNUE5gPZ0jVS6n83eaztnBVEd3wCDxDomPZHRSuzRuqUVifzuSN3Z0CI4J
         CR+G2kDljoRNF0tp03RqJytokln1Fd/dOVrmSO6iHoQcjhcYtc9MW9n1GgsyoHpns1yz
         iSDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788971528; x=1789576328;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LbwUECXSGtpoNpkapF0wkYICgxlHh/DhMmXXNw+XPjo=;
        b=GllEpvMOgMfmxJtEBVtkTZ0H/dLzHpDC4jyp1Ksi/yYXtqeSXUHqRQHPVMph67nAGB
         x0cHX5rc5PcvbyaMKl3k3Qg7K9TQ6cx8t3kfxCPzK0LEQaksfmwe/SquTFU+++uuBqn8
         YFx1G3rOXvKyE+8txlwnqm3ghIfgzVEWhjXa210hIRvXmBBSZwBdwN3GtNq2GmJCqNza
         mmcqyBi/y7hyTf6h7jHkRbxtlPuLH7NjEW07OcH3cjy8JW6lDzh0YTnRwre9k6NcQnCE
         Vcgw+lLKi6cU8OBWsxwsjY6XpncjyocrG+780IJfb05GoDnZ2qv6rKpfwwmWa9BzmkkA
         Vdpg==
X-Forwarded-Encrypted: i=1; AKwUvBxpVAn3Zqg96CxMqN2C0CE0NwPExzAxHyCP4wylQfh8M47wqHECvPWOqmWJvRn8CQFpb4redirb@vger.kernel.org
X-Gm-Message-State: AFuF++kCopn5d2rsxyciPY46/Eg6FkQq9/H1FJmM7tzat8CW2Z5VW8NK
	2wTMcwmvA/ijXb5VH8oXAdWFTBZEsrSScb/XeMYN1ZdPiNB4KNa8cNDu1g7+euy3EIoaGqUI0Io
	gWtF+N149f65+y1PMk6kpIAYRaYL05USp0BaMT+gQ
X-Gm-Gg: AYBFou3o5El/zKOinjb/ZilJTn6XOFdKTj/FYpNWa2gfb4Dc+2oXXjxcvbtCoanvhCJ
	HWAD9eq5r/p6bBSm+7rgeds+GL9hNwvlGJrgkaZnlm2QFT0oVWEmLQLPkGALzv1B339j3m/o/na
	JGvfjtWTI2Bl21YOkKA2vNaKpmeCR+shpdNhW5FNbs4TnVp+YUaBHmewI+N3UdulKWUDeBgMwQf
	Dy77X+wcyUB1Zs6mMwKJaBhx7dIehEJB1lkly8Y4GUgUOlDJxptnsDiSlnbzZqGLEtjlxR4QOag
	cXYd+ybvh4xyxYk3PvAjmRWP2SXuVq2dQA+xV1Q0MEDkN0W0D7cc/Uy9rvaanLDNMzR6nm2HdAI
	5TKet6/kbhOQfCjTUxFJKDzvCeagZ6YPPbbDM6PDL7Q==
X-Received: by 2002:a17:903:26d0:b0:2db:5c0a:f18c with SMTP id
 d9443c01a7336-2db5c0b15fdmr270389895ad.6.1788971526736; Wed, 09 Sep 2026
 09:32:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260829023251.474083-1-shakeel.butt@linux.dev> <20260901164741.GJ3004@cmpxchg.org>
In-Reply-To: <20260901164741.GJ3004@cmpxchg.org>
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Wed, 9 Sep 2026 09:31:55 -0700
X-Gm-Features: AcwNN1Xftn-5NEwC_biLDSz968e7PXUVQrICe5nQwJT8vOgIGskFQo4c9Lq4Bc8
Message-ID: <CA+0ovCgpQCaSH+_z+akR4ydhQBd+GSXNoP9mnngszj0Kt5pbow@mail.gmail.com>
Subject: Re: [PATCH] memcg: avoid charging the root memcg from obj_cgroup_charge_pages()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Meta kernel team <kernel-team@meta.com>
Content-Type: multipart/mixed; boundary="0000000000005e66a2065b0f6426"

--0000000000005e66a2065b0f6426
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The patched kernel (this patch on 28924df2a08f) no longer panics on
the attached reproducer.


On Tue, Sep 1, 2026 at 9:47=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
>
> On Fri, Aug 28, 2026 at 07:32:51PM -0700, Shakeel Butt wrote:
> > obj_cgroup_charge_pages() resolves the objcg to its memcg and calls
> > try_charge_memcg(), which does not short circuit the root memcg.  That
> > memcg can be the root memcg: obj_cgroup_is_root() reflects the memcg th=
e
> > objcg was created for and is never updated, while memcg_reparent_objcgs=
()
> > does redirect objcg->memcg to the parent on rmdir.  An objcg of a dying
> > child of root therefore passes every obj_cgroup_is_root() filter but
> > resolves to the root memcg.
> >
> > Folios keep the objcg they were charged with, so this is easy to reach
> > through zswap: allocate anon memory in a cgroup, move the task out,
> > remove the cgroup, then write to the root cgroup's memory.reclaim.  The
> > reclaimed folios are charged through the reparented objcg and end up in
> > refill_stock() with the root memcg:
> >
> >   WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940
> >    refill_stock+0x644/0x940
> >    try_charge_memcg+0x12d6/0x1570
> >    __obj_cgroup_charge+0x35/0xf0
> >    obj_cgroup_charge+0x1de/0x210
> >    obj_cgroup_charge_zswap+0x83/0x270
> >    zswap_store+0x1620/0x2000
> >    swap_writeout+0x94c/0x14c0
> >    shrink_folio_list+0x3388/0x52b0
> >    [...]
> >    try_to_free_mem_cgroup_pages+0x30d/0x830
> >    user_proactive_reclaim+0x504/0x840
> >    memory_reclaim+0x1f/0x30
> >
> > Beyond the warning, the charge is asymmetric: obj_cgroup_uncharge_pages=
()
> > skips refill_stock() for the root memcg, so the root's page counter gro=
ws
> > and is never uncharged.  It is not user visible, since memory.current i=
s
> > not exposed on the root, but it is a leak.
> >
> > Use try_charge(), which returns early for the root memcg, restoring the
> > symmetry with obj_cgroup_uncharge_pages().
> >
> > The above sequence was scripted into a standalone reproducer (zswap on,
> > swap on a virtio disk, 512MB of anon memory faulted in inside a child o=
f
> > the root cgroup, the task then migrated to the root cgroup, the child
> > removed, followed by "echo 600M swappiness=3Dmax > memory.reclaim" on t=
he
> > root) and run in a CONFIG_DEBUG_VM=3Dy VM.  It reproduces the splat on =
the
> > first zswap store of a reparented folio, with the same call chain as th=
e
> > report.  With this patch applied the splat is gone while the zswap stor=
e
> > count over the run is unchanged, so the same path is still exercised.
> > cgroup selftests test_zswap, test_kmem and test_memcontrol show no new
> > failures.
> >
> > Fixes: 20d6c1725228 ("memcg: avoid refill_stock for root memcg")
> > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > Closes: https://lore.kernel.org/all/CA+0ovCgWzUMK+nNbbtH7eV65Ca=3DfDN4O=
zu7iASgryjvv8Tk8zQ@mail.gmail.com/
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

--0000000000005e66a2065b0f6426
Content-Type: text/x-c-code; charset="US-ASCII"; name="reproducer.c"
Content-Disposition: attachment; filename="reproducer.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mtubfcki0>
X-Attachment-Id: f_mtubfcki0

LyoKICogUmVwcm9kdWNlciBmb3IgMTQ1LW1lbWNnLXZtX3dhcm4tcmVmaWxsX3N0b2NrLXJvb3Qt
Y2dyb3VwCiAqLwojZGVmaW5lIF9HTlVfU09VUkNFCiNpbmNsdWRlIDxlcnJuby5oPgojaW5jbHVk
ZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHNpZ25hbC5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1
ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgoj
aW5jbHVkZSA8c3lzL3N0YXQuaD4KI2luY2x1ZGUgPHN5cy9zeXNjYWxsLmg+CiNpbmNsdWRlIDxz
eXMvd2FpdC5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CgojZGVmaW5lIENHUk9VUF9ST09UICIvc3lz
L2ZzL2Nncm91cCIKI2RlZmluZSBWSUNUSU1fQ0dST1VQIENHUk9VUF9ST09UICIvdmljdGltIgoj
ZGVmaW5lIFNXQVBGSUxFICAiL3N3YXBmaWxlLjE0NSIKI2RlZmluZSBTV0FQX1NJWkUgKDUxMlVM
TCA8PCAyMCkKI2RlZmluZSBBTk9OX1NJWkUgKDQwMFVMTCA8PCAyMCkKCnN0YXRpYyBpbnQgd3Jp
dGVfZmlsZShjb25zdCBjaGFyICpwYXRoLCBjb25zdCBjaGFyICp2YWx1ZSkKewoJaW50IGZkID0g
b3BlbihwYXRoLCBPX1dST05MWSk7CglpbnQgcmM7CgoJaWYgKGZkIDwgMCkgewoJCXByaW50Zigi
b3BlbiAlczogJXNcbiIsIHBhdGgsIHN0cmVycm9yKGVycm5vKSk7CgkJcmV0dXJuIC0xOwoJfQoJ
cmMgPSB3cml0ZShmZCwgdmFsdWUsIHN0cmxlbih2YWx1ZSkpOwoJaWYgKHJjIDwgMCkKCQlwcmlu
dGYoIndyaXRlICVzIDwtICVzOiAlc1xuIiwgcGF0aCwgdmFsdWUsIHN0cmVycm9yKGVycm5vKSk7
CgljbG9zZShmZCk7CglyZXR1cm4gcmMgPCAwID8gLTEgOiAwOwp9CgovKiBzd2Fwb24oKSByZWZ1
c2VzIGEgc3BhcnNlIGZpbGUsIHNvIHRoZSBhcmVhIGlzIHdyaXR0ZW4gb3V0IGluIGZ1bGwgKi8K
c3RhdGljIGludCBzZXR1cF9zd2FwZmlsZSh2b2lkKQp7Cgl1bnNpZ25lZCBsb25nIHBhZ2Vfc2l6
ZSA9IDQwOTY7Cgl1bnNpZ25lZCBjaGFyICpoZWFkZXIgPSBjYWxsb2MoMSwgcGFnZV9zaXplKTsK
CXVuc2lnbmVkIGNoYXIgKnplcm9zID0gY2FsbG9jKDEsIDEgPDwgMjApOwoJdW5zaWduZWQgbG9u
ZyBsb25nIG9mZjsKCWludCBmZCA9IG9wZW4oU1dBUEZJTEUsIE9fUkRXUiB8IE9fQ1JFQVQgfCBP
X1RSVU5DLCAwNjAwKTsKCglpZiAoZmQgPCAwKQoJCXJldHVybiAtMTsKCWZvciAob2ZmID0gMDsg
b2ZmIDwgU1dBUF9TSVpFOyBvZmYgKz0gKDEgPDwgMjApKQoJCWlmICh3cml0ZShmZCwgemVyb3Ms
IDEgPDwgMjApICE9ICgxIDw8IDIwKSkKCQkJcmV0dXJuIC0xOwoKCS8qIHN0cnVjdCBzd2FwX2hl
YWRlcjogMTAyNCBib290Yml0cywgdGhlbiB2ZXJzaW9uL2xhc3RfcGFnZS9ucl9iYWRwYWdlcywK
CSAqIGFuZCB0aGUgIlNXQVBTUEFDRTIiIG1hZ2ljIGluIHRoZSBsYXN0IDEwIGJ5dGVzIG9mIHRo
ZSBmaXJzdCBwYWdlICovCgkqKHVuc2lnbmVkIGludCAqKShoZWFkZXIgKyAxMDI0KSA9IDE7Cgkq
KHVuc2lnbmVkIGludCAqKShoZWFkZXIgKyAxMDI4KSA9IChTV0FQX1NJWkUgLyBwYWdlX3NpemUp
IC0gMTsKCW1lbWNweShoZWFkZXIgKyBwYWdlX3NpemUgLSAxMCwgIlNXQVBTUEFDRTIiLCAxMCk7
CglpZiAocHdyaXRlKGZkLCBoZWFkZXIsIHBhZ2Vfc2l6ZSwgMCkgIT0gKHNzaXplX3QpcGFnZV9z
aXplKQoJCXJldHVybiAtMTsKCWZzeW5jKGZkKTsKCWNsb3NlKGZkKTsKCXJldHVybiBzeXNjYWxs
KFNZU19zd2Fwb24sIFNXQVBGSUxFLCAwKTsKfQoKaW50IG1haW4odm9pZCkKewoJY2hhciBwaWRf
c3RyWzMyXTsKCWludCBjaGFyZ2VkX3BpcGVbMl0sIHBsYWNlZF9waXBlWzJdOwoJcGlkX3QgY2hp
bGQ7CgljaGFyIHN5bmNfYnl0ZTsKCglzZXR2YnVmKHN0ZG91dCwgTlVMTCwgX0lPTkJGLCAwKTsK
CgkvKiB6c3dhcCBtdXN0IGJlIG9uLCBvciBub3RoaW5nIGlzIGNoYXJnZWQgdG8gdGhlIG9iamNn
IGF0IGFsbCAqLwoJd3JpdGVfZmlsZSgiL3N5cy9tb2R1bGUvenN3YXAvcGFyYW1ldGVycy9lbmFi
bGVkIiwgIlkiKTsKCWlmIChzZXR1cF9zd2FwZmlsZSgpIDwgMCkgewoJCXByaW50Zigic3dhcG9u
OiAlc1xuIiwgc3RyZXJyb3IoZXJybm8pKTsKCQlyZXR1cm4gMTsKCX0KCXdyaXRlX2ZpbGUoQ0dS
T1VQX1JPT1QgIi9jZ3JvdXAuc3VidHJlZV9jb250cm9sIiwgIittZW1vcnkiKTsKCWlmIChta2Rp
cihWSUNUSU1fQ0dST1VQLCAwNzU1KSA8IDAgJiYgZXJybm8gIT0gRUVYSVNUKSB7CgkJcHJpbnRm
KCJta2RpciAlczogJXNcbiIsIFZJQ1RJTV9DR1JPVVAsIHN0cmVycm9yKGVycm5vKSk7CgkJcmV0
dXJuIDE7Cgl9CgoJcGlwZShjaGFyZ2VkX3BpcGUpOwoJcGlwZShwbGFjZWRfcGlwZSk7CgoJY2hp
bGQgPSBmb3JrKCk7CglpZiAoY2hpbGQgPT0gMCkgewoJCWNoYXIgKmFub247CgkJdW5zaWduZWQg
bG9uZyBsb25nIGk7CgoJCWNsb3NlKGNoYXJnZWRfcGlwZVswXSk7CgkJY2xvc2UocGxhY2VkX3Bp
cGVbMV0pOwoJCXJlYWQocGxhY2VkX3BpcGVbMF0sICZzeW5jX2J5dGUsIDEpOwoKCQlhbm9uID0g
bW1hcChOVUxMLCBBTk9OX1NJWkUsIFBST1RfUkVBRCB8IFBST1RfV1JJVEUsCgkJCSAgICBNQVBf
UFJJVkFURSB8IE1BUF9BTk9OWU1PVVMsIC0xLCAwKTsKCQlpZiAoYW5vbiA9PSBNQVBfRkFJTEVE
KQoJCQlfZXhpdCgxKTsKCQkvKiBjb21wcmVzc2libGU6IHpzd2FwIG9ubHkgY2hhcmdlcyB3aGF0
IGl0IGFjdHVhbGx5IHN0b3JlcyAqLwoJCWZvciAoaSA9IDA7IGkgPCBBTk9OX1NJWkU7IGkgKz0g
NDA5NikgewoJCQltZW1zZXQoYW5vbiArIGksIDB4NDEgKyAoaSAlIDcpLCA0MDk2KTsKCQkJKih1
bnNpZ25lZCBsb25nICopKGFub24gKyBpKSA9IGk7CgkJfQoJCXdyaXRlKGNoYXJnZWRfcGlwZVsx
XSwgIngiLCAxKTsKCQlwYXVzZSgpOwkJLyoga2VlcCB0aGUgZm9saW9zIGNoYXJnZWQgKi8KCQlf
ZXhpdCgwKTsKCX0KCWNsb3NlKGNoYXJnZWRfcGlwZVsxXSk7CgljbG9zZShwbGFjZWRfcGlwZVsw
XSk7CgoJc25wcmludGYocGlkX3N0ciwgc2l6ZW9mKHBpZF9zdHIpLCAiJWQiLCBjaGlsZCk7Cgl3
cml0ZV9maWxlKFZJQ1RJTV9DR1JPVVAgIi9jZ3JvdXAucHJvY3MiLCBwaWRfc3RyKTsKCXdyaXRl
KHBsYWNlZF9waXBlWzFdLCAieCIsIDEpOwoJcmVhZChjaGFyZ2VkX3BpcGVbMF0sICZzeW5jX2J5
dGUsIDEpOwoKCS8qIGNncm91cCB2MiBkb2VzIG5vdCByZWNoYXJnZSBvbiBtaWdyYXRpb24sIHNv
IHRoZSBmb2xpb3Mga2VlcAoJICogcG9pbnRpbmcgYXQgdmljdGltJ3Mgb2JqY2cgYWZ0ZXIgdGhl
IG93bmVyIGxlYXZlcyAqLwoJd3JpdGVfZmlsZShDR1JPVVBfUk9PVCAiL2Nncm91cC5wcm9jcyIs
IHBpZF9zdHIpOwoKCS8qIHJtZGlyIHJlcGFyZW50cyB0aGF0IG9iamNnIHRvIHRoZSBST09UIG1l
bWNnIHdoaWxlIGxlYXZpbmcKCSAqIG9iamNnLT5pc19yb290IGZhbHNlLCB3aGljaCBpcyB3aGF0
IGRlZmVhdHMgdGhlCgkgKiBvYmpfY2dyb3VwX2lzX3Jvb3QoKSBndWFyZCBpbiBvYmpfY2dyb3Vw
X2NoYXJnZV96c3dhcCgpICovCglpZiAocm1kaXIoVklDVElNX0NHUk9VUCkgPCAwKQoJCXByaW50
Zigicm1kaXIgJXM6ICVzXG4iLCBWSUNUSU1fQ0dST1VQLCBzdHJlcnJvcihlcnJubykpOwoKCS8q
IHJlY2xhaW0gb24gdGhlIFJPT1Q6IHRoZSB6c3dhcCBjaGFyZ2UgbGFuZHMgb24gcm9vdF9tZW1f
Y2dyb3VwIGFuZAoJICogcmVmaWxsX3N0b2NrKCkgdHJpcHMgVk1fV0FSTl9PTl9PTkNFKG1lbV9j
Z3JvdXBfaXNfcm9vdChtZW1jZykpICovCgl3cml0ZV9maWxlKENHUk9VUF9ST09UICIvbWVtb3J5
LnJlY2xhaW0iLCAiMUciKTsKCglraWxsKGNoaWxkLCBTSUdLSUxMKTsKCXdhaXRwaWQoY2hpbGQs
IE5VTEwsIDApOwoJcmV0dXJuIDA7Cn0K
--0000000000005e66a2065b0f6426--
