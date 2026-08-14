Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30E845DF63
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 11:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786706639; cv=none; b=R/daODlLO/HafWWSvHQT5jzscT6GPZUpMWhMtr56vPPIvbwRIL/XYSy1fvprMjdiVVTKQ2/qdRGuMKHS9FU1GMsjudYh8xVxj1Zyft0glM90AOBFO1lJ2+qK+O/V1CUppO6h8WKNaEeW1UdZ6hRVQZpovikaRPH1sl3V7J/w6RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786706639; c=relaxed/simple;
	bh=LrBZvHrwrXM0R1lVgGgVnfZgn4AmW0zo3cE10Pz7gjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QeHLkiaXodiC/t7J463B6lgpDl1wyDd3msXFOdBScKXzK7V1VbZ18TGzYf0xHXFBLnOetX86UpxjJ9CWdwGMFk+KexG4unMNN8amJGkDnlpZR7PoZBXyKhj3duxxw+Y54Hzm91FIpA6SufcSd1u/8a+tU/LO94Z/+Ke1itfdEK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZwVPNWd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZwVPNWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327A81F00AC4
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 11:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786706633;
	bh=rfADc6/R72hwdaY25fr6WLriArvVrwd+ff7yRnwVQRk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NZwVPNWdgl5G6msuqZL9Mkx1Bop2gkMomPd9lMJEeesesx6ly6TLavXoZW/bkVkek
	 HYGjgpPPIA5N7evtMozSBVC3pHLDLs+zGvALr3Bledk8VgcnNZiGIW1+5+heax77Rz
	 3dSenU7yBh0xYNLUZaBAMkJ96NpwMBQh135gaQ0FMZ/Ne/rZ+CeXGbxnaBbYOf0Ld+
	 MlrlOSXDPXFvHs/HbpjNli1SKLqAHV6eCt6z8OiKn0bVFID7AfBBtOJrCMMwfE7Qlx
	 2KY5pVL41kHgFKxe3QgvV7IK304Xb0eTfd9e7x8UMIA3Ltqdb9QFGRypCM6L8SoNmB
	 S6S5YTyV+zFHw==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-934a3d14924so86106785a.2
        for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 04:23:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpyYdiRljj4cKvoyH/5i1gntNdVFZsOknnhzhD9tWjWsFWYlY9xAzXanmbA9SthnH8gePcUcy6v@vger.kernel.org
X-Gm-Message-State: AOJu0YxXQhknfsjJFx7yVhM0pRgkcNruBCQyArS1IdyfHJbit7wMfJB1
	cZ03gyUneXXMzyVO0y43yEtua80VgTokjlWf1HzJ+B4cs3bpOcV5dAuaPMAGExGn6jXfSOLf8Po
	SPU9zGOQFchFs2bbGClQakZPuZvRrTYw=
X-Received: by 2002:a05:620a:45a0:b0:92e:7533:ef63 with SMTP id
 af79cd13be357-936d2021e07mr461450885a.13.1786706632605; Fri, 14 Aug 2026
 04:23:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260814074705.939721-2-mambaxin@163.com>
In-Reply-To: <20260814074705.939721-2-mambaxin@163.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 19:23:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y+kGUH7TjKEGU+hbwCotHeubNdbJtoBExP+Ya-Wf3fWA@mail.gmail.com>
X-Gm-Features: AUfX_mxn4RXlpo4fupbSBD57H9Nh3esjr7Y2wqN9hyd0KIKiCgDKSWpkR8DcuIQ
Message-ID: <CAGsJ_4y+kGUH7TjKEGU+hbwCotHeubNdbJtoBExP+Ya-Wf3fWA@mail.gmail.com>
Subject: Re: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id
 on swapless host
To: mambaxin@163.com
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org, 
	david@redhat.com, v-songbaohua@oppo.com, hughd@google.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	gregkh@linuxfoundation.org, jose.fernandez@linux.dev, stable@vger.kernel.org, 
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com, 
	David Hildenbrand <david@kernel.org>, Kairui Song <ryncsn@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Sasha Levin <sashal@kernel.org>, 
	chenxin <chenxinxin@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 3:48=E2=80=AFPM <mambaxin@163.com> wrote:
>
> From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
>
> [ Upstream commit 63b02a9409cb5180398491b093e48bcb5315f5fb ]
>
> lookup_swap_cgroup_id() passes swap_cgroup_ctrl[type].map to
> __swap_cgroup_id_lookup() without checking that the type was ever
> registered via swap_cgroup_swapon().  On a swapless host every ctrl->map
> is NULL, so __swap_cgroup_id_lookup() dereferences NULL + a scaled
> swp_offset().
>
> Since commit bea67dcc5eea ("mm: attempt to batch free swap entries for
> zap_pte_range()"), zap_pte_range() -> swap_pte_batch() calls
> lookup_swap_cgroup_id() on any non-present, non-none PTE that decodes as =
a
> real swap entry, without first validating it against swap_info[].  A
> single PTE corrupted into a type-0 swap entry takes the host down at
> process exit.

Thanks for the patch. However, we have a strict check to ensure that
this is only done for valid swap entries:

static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
{
        pte_t expected_pte =3D pte_next_swp_offset(pte);
        const pte_t *end_ptep =3D start_ptep + max_nr;
        pte_t *ptep =3D start_ptep + 1;

        VM_WARN_ON(max_nr < 1);
        VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));

        while (ptep < end_ptep) {
                pte =3D ptep_get(ptep);

                if (!pte_same(pte, expected_pte))
                        break;
                expected_pte =3D pte_next_swp_offset(expected_pte);
                ptep++;
        }

        return ptep - start_ptep;
}

I don't know why this can happen on a swapless system.

>
> We hit this in production on a swapless 6.12.58 host: ~1s of
> "get_swap_device: Bad swap file entry 3f800204222bb" (do_swap_page() bein=
g
> correctly defensive about the same entry) followed by
>
>   BUG: unable to handle page fault for address: 000003f800204220
>   RIP: 0010:lookup_swap_cgroup_id+0x2b/0x60
>   Call Trace:
>    swap_pte_batch+0xbf/0x230
>    zap_pte_range+0x4c8/0x780
>    unmap_page_range+0x190/0x3e0
>    exit_mmap+0xd9/0x3c0
>    do_exit+0x20c/0x4b0
>
> syzbot has reported the identical stack.
>
> The source of the PTE corruption is a separate bug; this change makes the
> teardown path as robust as the fault path already is.  Every other caller
> of lookup_swap_cgroup_id() is downstream of a get_swap_device() that has
> already validated the entry, so the new branch is cold.

If the source is PTE corruption, I think we should fix the corruption
itself rather than work around it here.

Best Regards
Barry
