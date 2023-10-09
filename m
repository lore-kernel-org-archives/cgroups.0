Return-Path: <cgroups-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FB0E95A8E
	for <cgroups@archiver.kernel.org>; Mon,  9 Oct 2023 14:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbjJIOsL (ORCPT <rfc822;cgroups@archiver.kernel.org>);
        Mon, 9 Oct 2023 10:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbjJIOsK (ORCPT
        <rfc822;cgroups@vger.kernel.org>); Mon, 9 Oct 2023 10:48:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428BA9E;
        Mon,  9 Oct 2023 07:48:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id ECB481F390;
        Mon,  9 Oct 2023 14:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1696862887; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2r+xufjEknjT7sEh+bCptQz2HS1nKt470rn+ZYGrlEg=;
        b=Iswnx7CbLZNKUGYVkchzDH7T8XwYIPNswL6QvNweRirwKg68HDptxu86eh6FTdIfFIT7+Z
        YqpumYY9rDg8oblcUS9fwdqEQ48md1PDYZYT+38+M3KBk9QErlM9w/m0tnn3G+P2/mTSvS
        dnnCL1dYO9LTFRANEniYVWl0U/3ZUQ8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A630113905;
        Mon,  9 Oct 2023 14:48:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mvLUJ6cSJGW0GgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Mon, 09 Oct 2023 14:48:07 +0000
Date:   Mon, 9 Oct 2023 16:48:06 +0200
From:   Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yonghong.song@linux.dev, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tj@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, yosryahmed@google.com,
        sinquersw@gmail.com, cgroups@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 2/8] cgroup: Add new helpers for cgroup1
 hierarchy
Message-ID: <2q4bqtfixslupka3sod5tiahalbimocahsw75auoyx5gfowpfd@e6fgqkhzz7kg>
References: <20231007140304.4390-1-laoar.shao@gmail.com>
 <20231007140304.4390-3-laoar.shao@gmail.com>
 <5ne2cximagrsq7nzghbsmimrskz77drkj4ax2ktyawquvu2r77@dl4tujtwlnec>
 <CALOAHbDdWtM8+vePYm71xtX_w_6fAANTV6qAkqC-vaiLe0Gmog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="d4omd3rg5jrowc2j"
Content-Disposition: inline
In-Reply-To: <CALOAHbDdWtM8+vePYm71xtX_w_6fAANTV6qAkqC-vaiLe0Gmog@mail.gmail.com>
Precedence: bulk
List-ID: <cgroups.vger.kernel.org>
X-Mailing-List: cgroups@vger.kernel.org


--d4omd3rg5jrowc2j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 09, 2023 at 09:10:04PM +0800, Yafang Shao <laoar.shao@gmail.com> wrote:
> Hao also pointed out the use case of a 3rd partry task[1].

Sigh (I must have expulsed that mail from my mind).

Is the WARN_ON_ONCE(!cgrp); of any use when
__cset_cgroup_from_root() has
        BUG_ON(!res_cgroup);
?

Thanks,
Michal

--d4omd3rg5jrowc2j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZSQSpAAKCRAGvrMr/1gc
jkkGAQDELrcd+tTbfOX3oTNNFgJwfkqBGWXWhaAU6OAFcHlu0wEAwc/lty0L7gZd
xr//ca826RHMjnQi3OjS8gCt9h5tog8=
=5gCm
-----END PGP SIGNATURE-----

--d4omd3rg5jrowc2j--
