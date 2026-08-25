Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC71351C13;
	Tue, 25 Aug 2026 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787669955; cv=none; b=ncWEXzbcdgt8QP36JSMamGsYnwpviJ5/zWVEs4zaoSnPpEHByYJ1aiQWB8vP1TnVu0hscEyx0F5741gxzwrn/O/ULOPlgCqXsh4wKzlZ5P5x2PkKVkkWrerjsqMnIhOqTnYFmpV1S+U9UplT/w+uLbyTuATBpcX3sUQ/Hb9lN3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787669955; c=relaxed/simple;
	bh=kfGPEncLi1JjdqMbHvY9oy5fgibv7ARwTmJ1vWHEAoI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=CRUB9yBcfohW2D8xDSpohzvdqgf+S30hqubkcLVPgXObW77hgRyzMMZRtXXU6r27eXhOZRIlZIL6U3Em3r2O2Vx8/P8wYUFf8dhTXg617xIgscAF0aaxdWS12sLVQ6IBi7hnMoxu/7D5iPSdHvT5ZhdLR+HuoQBmRgMW9M41z+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJF4ssCT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJF4ssCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759181F000E9;
	Tue, 25 Aug 2026 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787669948;
	bh=CS16TY7QXHbRdzvC7fXYJVGDsq3ymYJ2NMTpQ4DNreQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=kJF4ssCTQSYgJMv5xEdodK+nM1bhIGCXpCHUCFLQoOj6EDCOdQj2SQZ50L9lsDYua
	 1ung9XDkhv94e6tn/CPKv/Xm4EgS5A2uqK7xyZvlsNgIk8K8vRx3uMnbIS5DgQUs/t
	 2WmfczScGuy3RDIXguE+0smLtPmzccR8V5GRzX73NGlFek1vThzA3GGvTyrLBBeIWr
	 NohGEIOckjSaTZMUPYd6e+wHPowfpESiEtNszwOgD2qUUsEtesJwYuMhgZd+9xx2FO
	 W8bikb/7fo9bj+M5xHkAi4fiZ7BZbB1lVwdhRXpzPHHagJtWoyrjfD0cRahSREW9kj
	 5617+wo/NZFpg==
From: Christian Brauner <brauner@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Tejun Heo <tj@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: Meta kernel team <kernel-team@meta.com>, driver-core@lists.linux.dev, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Christian Brauner <brauner@kernel.org>
In-Reply-To: <20260821050507.2161607-1-shakeel.butt@linux.dev>
References: <20260821050507.2161607-1-shakeel.butt@linux.dev>
Subject: Re: [PATCH 0/4] kernfs: remove kernfs_rwsem from dentry
 revalidation
Message-Id: <20260825-grabmal-erwachen-aufatmen-b62c5d6c220e@brauner>
Date: Tue, 25 Aug 2026 16:58:58 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1613; i=brauner@kernel.org;
 h=from:subject:message-id; bh=kfGPEncLi1JjdqMbHvY9oy5fgibv7ARwTmJ1vWHEAoI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT1rt21etv3n4csDQQ9fj7iffizI3nnRWU7nan3Mlv/f
 Qp/Esog2VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR7myGf9qy/UsvqM1NP1m/
 5WONVnhXylL+2TxxYv5NRs3MC6Z2LGJkWB6dZiVzI+L2i5iX2hJNbC47pq3qkE77f/JH3uPnbWt
 fcAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Thu, 20 Aug 2026 22:05:03 -0700, Shakeel Butt wrote:
> kernfs: remove kernfs_rwsem from dentry revalidation
> 
> At Meta, we are seeing important system daemons that poll cgroupfs and
> sysfs geth stuck in kernfs_dop_revalidate() for minutes. The two that
> hurt most are the ones we can least afford to lose: oomd, which decides
> what to kill when a machine runs out of memory, and below[1], which
> records the telemetry used to understand what happened afterwards.
> 
> [...]

Applied to the vfs-7.4.kernfs branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.kernfs branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.kernfs

[1/4] kernfs: Use VFS lookup context in d_revalidate()
      https://git.kernel.org/vfs/vfs/c/b3c97f5cb084
[2/4] kernfs: Prepare directory revisions for lockless reads
      https://git.kernel.org/vfs/vfs/c/272e0997df44
[3/4] kernfs: Avoid namespace dereference in d_revalidate()
      https://git.kernel.org/vfs/vfs/c/e1c629a8dbc7
[4/4] kernfs: Remove kernfs_rwsem from dentry revalidation
      https://git.kernel.org/vfs/vfs/c/8c6ad578e2f0

