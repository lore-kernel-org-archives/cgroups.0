Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D94583AD9
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 16:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788885945; cv=pass; b=m0hdaWq7WWtTIXewiM5neREcpBOeNEdeDBXm/K2DNa+YtAk9L2gCpVgcCUuURNOukIof+BjaewNJnU8ubK4UOKpaXQwp7YSxBUcUSTJYeTGBu974PcGEx8BUq3XJgx2o93LJTeoNkCzvYEa+Z2S4w6/WjjTkQdmNmcnlNdipIms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788885945; c=relaxed/simple;
	bh=Emh4r7YyMhyoPJO25yHzs0ZWlSLxOb8NX5/sVQuWrzk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mfPLwAPRrs3gjaXPOsoLTKfxna6srNWF8Sb6yXo1cbEleUyyz41qILVYpi7pTpMJtk7OcugNGT+6edKcrSLXGuF7qSR/3St3QSHyn8vcJLvujCuiXhCif29uW862LUtlqWtFEzynHcvVycyLCJvZwfyEY5D5BggtZEDa6TJgck4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wdn6dOB/; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wdn6dOB/"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-482dd6ee390so5556930f8f.3
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 09:45:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788885941; cv=none;
        d=google.com; s=arc-20260327;
        b=BXSzw92BsnLvKxoL65+2ciJNoqKWm/l+JG2o1yxTQvDJ19K3o1WZKhrusANSWm72Cx
         CG/qko1+O4C3vvSgACdagiCrJeLoeFnY6uhdFZzaa7TOMBaOizI+f6PIMZSu94WWdTLK
         N21VGRIZ9Y8BQjVh3QnCIJmllJSyL6jYbdeRA0VAiZ02DCzbgxYVMjkINjTgQnI8be2E
         LZb23cjjLroznBdCBWqOdctMokQXiZ85OIoLKD0iuxPeAeXcD7xYZFqynETS9e3WPGyD
         9pt22q7gAK36nz9oGVNLWm+qkjRecFn2r2dwL9KP2s+6Uv/rW3gwRKIYLtVREE4HphZ+
         mceQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Emh4r7YyMhyoPJO25yHzs0ZWlSLxOb8NX5/sVQuWrzk=;
        fh=MJuk5pNOddp3M/NVEAuTYyrZcgWf0CxApxz7GXtft5M=;
        b=Mjzuz3FetKlIFwX+7UvexifEsISktlnKKtQa+1oUVo1icf+ejU6mUm4jRda72u6wxF
         t8d+kbIpLcKjYqBQMKXY5slfSqb0y/eSPuUbCeQgnS6TvyKfpnt7/hdSpg5PP+Z2hZlf
         hB0rrvPL8Evrvm3CaA93+8sIwmTmiNTOrA2F1k4vGYi2mc1b1Xkm25m40afV9hKKKXIu
         VXjRqvW+pF6n33rsu/S4cHTBgdpTlqoGdszdBgrGsaBRVpx5pQs/oYqnEcD2HgAQDABK
         jmDy9/0uBHnSyWgd6M26hSkIl2N23PPx5xwyQjayCDKn7tRQkB9FLJ8J5FcvEYepO+k9
         poHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788885941; x=1789490741; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Emh4r7YyMhyoPJO25yHzs0ZWlSLxOb8NX5/sVQuWrzk=;
        b=Wdn6dOB/fPzumkeFFnlaTi1feOGL5RxL1vn/7avuT33LfCaRwx4XzrE70JwUKIGheX
         OQkWi7gUiTxrt1q0vPf7WFNQ04oMnhBi5ZuCsQX9pmtd6FWcdtH7WcZgKKGF8V+FpDmV
         SaA/E+4Ei4Ifzxfru/+wMHG2rwwsAsAWj2eZng+iteVJif2EjvAYmECbDd6AFiKBonYe
         CnJk79NNnfWmMSN/YQLXfUckLtm583IxrR27oqN4y4iWqsmtXeY7lot3JkttkGhLMPQc
         cSFCpjuGsxWxCSNGA9yNT30s2F14qBkd58F8CcTdIxEq0NmPret3ywPC4VDQ8CAYe/zy
         iXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788885941; x=1789490741;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Emh4r7YyMhyoPJO25yHzs0ZWlSLxOb8NX5/sVQuWrzk=;
        b=pdiFokxDGxVDuSwT/WN6tkeBJrT7HWj0ULeE9GK0u1zsoPu1sgHEOwZMbVXbmU+xYJ
         9vj/b37QaryxjKMEvQPZrkbcTQUo4oq18SI/6Jzc8qeeNzBIQG9pD1pgtaMUmVqLlXQ8
         Surych0I7W8FSYfilsmJwBU7mU6ZSfrzzQt4nNF3mF742gs9UUnX9lY7wfyCmiMgS4FA
         o4YuXDP4pMGiuGGNuJCQUc6RKG/sBuazfwqeVMfD3oUdMbVhFhyac68SqG2UTrng5/E3
         UhNRxxAedoBs81CX0j7IOI+R+8bxo7eksDpqK/IbU2vn/rfjvw7UBIQRIlJDxlzNLyXn
         /gXQ==
X-Forwarded-Encrypted: i=1; AKwUvBz3Wy4ZGEyXMJ6HK9tPRztpWgbwX3OZ5nJJ0PzgL7zMV628PbfHMYqg3n6GYG20j+FKBNYz3roW@vger.kernel.org
X-Gm-Message-State: AFuF++kcCo3CQ2j3pMSRMBk3EnDXvzSviS+H+HlyMD2RfK1/D8yPNi+7
	Yx4g2OdebzTyIk8+HsqqwjN3gV5xYbfhZ9tAEqnqS/mH4de3j9rDEhLnbwCUm7tCH/37QAZiz+M
	L8n5EGzpTnx6n57DIcoW9LB7EuocRNLQ=
X-Gm-Gg: AYBFou0cTfGKLQ6FzdYwAQE70P6C6aIqyWYbHmpsQ0fkDVOmv8KQF0rgV3CuGAzetYS
	vpSCaz+q3Ka+t9julHKyLpFj0RMOS6ozV8kQ87pzI/4fdZjSbui30L/xzJoxyPBlHdlc3sgg8dg
	feOivlsVA5DTc/TV0AliEA7evJHo81hTVoFs4JfXL9ImHWAvWoq/zHa3uAnDQJCVR3eT95rjujv
	mp7ZWaFPGIR1oUZ0DcZzefJznBEsTbTXIesMT0Mg4qCf4qtVA7lYpAzhU+ARrSgCntnmyatMtvM
	pRHVAcGXpU+qH0j+NXPGJqMJaOLZdOYxgsFF68KMelAYfhysTGweJQ8jDN5uC3UQV1rPTogGkQ3
	/
X-Received: by 2002:a05:6000:288e:b0:485:8c16:a33f with SMTP id
 ffacd0b85a97d-4858c16a5d0mr27884309f8f.52.1788885941502; Tue, 08 Sep 2026
 09:45:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
In-Reply-To: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 8 Sep 2026 09:45:29 -0700
X-Gm-Features: AcwNN1VKHJXv7OJIvb-6r4VRgrNUVYMe2NFk6RQyVFERhDXV76DkbFan7U8qPdI
Message-ID: <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 4:30=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 9/4/26 23:14, Nhat Pham wrote:
>
> Hi,
>
> > To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap fol=
ks -
> > I need some help here.
>
> I'll mostly ignore swap-related stuff because (a) -EBUSY and (b) we have =
quite
> some swap experts around :)
>
> Reading below, I do wonder if the swap subsystem needs some more coordina=
tion
> and collaboration?
>
> For example, maybe having bi-weekly/monthly meetings to get everybody ali=
gned
> and uptodate could be something reasonable?
>
> This approach has proven fairly helpful in areas where (1) multiple compa=
nies
> are involved (2) many concurrent development is happening, and (3) people=
 have
> different priorities and requirements.
>
> Is there already something like that to organize development? Should we g=
et
> started with that?

Hi David!

Thank you for your suggestions :) More collaboration and communication
is definitely needed here. Conference is a good place for this, but
it's not something we can do very frequently, and many folks could not
attend (visa issues, etc.).

A bi-weekly/monthly series of meetings sound very appealing. Swap
contributors are very spread out (China, NorAm, Europe, etc.), so
coordination will be tricky, but let us figure out something.
