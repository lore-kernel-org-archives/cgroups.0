Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC773B8139;
	Thu, 23 Jul 2026 09:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799334; cv=none; b=MP5rLc1jy9SYIN04hKyFvwHeuHSXk5ECw3it4/PWpd/QapMOqj0NZ2OR87+lt7/kFmZVVw/FleoWAYcmuYxMJv0AZ8OtxlWC9fLl/UC0EgLHHLKcvOtuDzqG8CH3mLmQOlOlppCfoCizXOahn3fO/fQkSVYYHuz3xG7keF7qO/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799334; c=relaxed/simple;
	bh=P1ri9jIlf5K46sMu+BdMRUHIR8r3nUqwsZr/hAYcuzA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ioAQbMkJjpxuEvXIF/BONMlD+4ZFA5bY9z85fFUuyRjRmTgUus93b6CthhnXmsN9FwpTEUv1PVTDmUyho5r7l0uUGx3HW34Yry1h0g4bwhL+I6OBHs8TllgRtu46YMAi3unAY4bv09HXS69eQFzsFHxSm3LCcVlWsFx1Pb3HT1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJKTuk4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJKTuk4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B28F1F000E9;
	Thu, 23 Jul 2026 09:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784799333;
	bh=aZZCZ/d/c3xLlwTJG317mBGnb8THEbPIiA7jBD/2pKc=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=HJKTuk4Y/BNCfJUH/Scq+NVzyNgpwaaMcN7elruFMLa6kysXsv3I7IxKHDCxBPw47
	 DIuZcGDZYUIgna31G1KKOk3CIP/z9vxNh8AnE3qHOXZ/Ufk+9Rs7sBHfryT3TXEtxP
	 B3dSRJRgiLuz5y8PlT/EWwZP+gSQKGMCWiHM4N6I+yuNPS3nuRq/xxb8CPgwy/3TRc
	 8B4SOK5+OEL2aIws8L8TSCvwnXSwfi/DeYuEBBbEsiMAGRNbrn+Vw6VV7usFqaUAyz
	 7X7qUJvSKXz/m6ZICFTxewrNh+FCRQfrlFmnyX8vNjoftu6SbwibBymgEQdUuze6W1
	 FcOnthHcz5bzw==
From: Christian Brauner <brauner@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com, 
 dgc@kernel.org, qi.zheng@linux.dev, baolin.wang@linux.alibaba.com, 
 cgroups@vger.kernel.org, clm@fb.com, dsterba@suse.com, hannes@cmpxchg.org, 
 hughd@google.com, jack@suse.cz, linux-btrfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
 Al Viro <viro@zeniv.linux.org.uk>, kernel-team@meta.com, 
 Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260715103516.2410175-1-usama.arif@linux.dev>
References: <20260715103516.2410175-1-usama.arif@linux.dev>
Subject: Re: [PATCH v2] fs: push nr_cached_objects memcg gating into
 individual filesystems
Message-Id: <20260723-wuseln-nachwachsen-befeuern-82f31d54fd8d@brauner>
Date: Thu, 23 Jul 2026 11:35:07 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=908; i=brauner@kernel.org;
 h=from:subject:message-id; bh=P1ri9jIlf5K46sMu+BdMRUHIR8r3nUqwsZr/hAYcuzA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlPkiQnrH6ltPc6U1T9m/Wnse0usZoz8KbU2fL2liV2
 BxfrXrZt6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiLtEM/zQieN+tus9Xurtw
 8eq2k9ft5mitPNCzuWpdxBxm1SV37vEwMtxc8rG3vvm1YUjMhOXBhREVpvKbmtaVHDmuHOx2KOJ
 hMT8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 15 Jul 2026 03:35:16 -0700, Usama Arif wrote:
> fs: push nr_cached_objects memcg gating into individual filesystems

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] fs: push nr_cached_objects memcg gating into individual filesystems
      https://git.kernel.org/vfs/vfs/c/d5233434ecd5

