Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FEB387345
	for <cgroups@vger.kernel.org>; Sat, 12 Sep 2026 03:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789182583; cv=none; b=IJY5pDzivap5dTpokt8K1BkBRMPworrWw60zbwuowxMJS625weGl0G5WzsDn82JQoE77xTbmzIn/YxOg4E92LcY4RoWAywdq2sSVKFxCLalIQvf/jFVOpof/AsyXpD9RxxxwacA+uwoFeme9HfIGYAq1BbEyLkghe+JZsOqXG70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789182583; c=relaxed/simple;
	bh=Iu8FewysYP/Ep//xGcr71N/KuWpAf/0JZgUTITgcNRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W4uqhpXu8qk8DoXJEzHZ22gCy6arkKb2cPO4xzQyp/9iGgr0UTxvcc5uaDot/TifG5HcwUgCKckIrNVke4bi0YVPlq4yA6tgjmjLB1Y6fCqP6jzL3CWegerVh62XDJjmUfXfYmRHz3JrHuyFD7CkQspiVcnxcD84zXe9FjgLd9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HKAkhPLS; arc=none smtp.client-ip=91.218.175.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HKAkhPLS"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Iu8FewysYP/Ep//xGcr71N/KuWpAf/0JZgUTITgcNRo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789182578; v=1; x=1789787378;
 b=HKAkhPLShVk3N0r/3FWzzsFzOrhVyMRzoZO7EdMoAZ01GbxWFrh5oJYzn0VI8bm7f4CGhy5D
 6mMkx+e79pEFJEQ033DW8p8qA8kqnHymKyVV8NDlRK0pgnuUo+NKBwKLFsiEMB5zrVjPAPJxYRC
 7SwCqa9cIFS+gj1vUyICCQ0k=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 90df69297e1a59c2;
	Sat, 12 Sep 2026 03:09:28 +0000
X-Mizu-Trace-ID: 90df69297e1a59c2
X-Migadu-Flow: FLOW_OUT
Date: Fri, 11 Sep 2026 20:09:27 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Sandeep Dhavale <dhavale@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Christian Brauner <christian@brauner.io>, 
	Meta kernel team <kernel-team@meta.com>, driver-core@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kernfs: Remove kernfs_rwsem from dentry revalidation
Message-ID: <aqTB1AVmFVs08T19@linux.dev>
References: <20260821050507.2161607-1-shakeel.butt@linux.dev>
 <20260821050507.2161607-5-shakeel.butt@linux.dev>
 <CAB=BE-QMyzKT-o=gbhdp3g8JSqQgRiTFzxTX9vEBmCttABrmdw@mail.gmail.com>
 <aqRWuffGKczUhegT@linux.dev>
 <CAB=BE-SjW76gWr0kZcPnEjXOwt90vCV0TJeFuYEGV1Kt4Y1HWw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=BE-SjW76gWr0kZcPnEjXOwt90vCV0TJeFuYEGV1Kt4Y1HWw@mail.gmail.com>

On Fri, Sep 11, 2026 at 02:11:53PM -0700, Sandeep Dhavale wrote:
> > Hi Sandeep, thanks for the report. Do you have a reproducer? If yes, can you
> > reproduce with this series?
> >
> Hi Shakeel,
> No luck with the reproducer yet, and reports have been sporadic.
> 
> > I think first we need a real reproducer before considering anything. I would not
> > add a check unless we have proof that it is really needed.
> 
> Ok, I understand. Do you have any opinion on the suspected call chain
> which makes dentry->d_inode = NULL; ?

I don't see how reclaim can set dentry->d_inode = NULL for a dentry with
elevated dentry->d_lockref.count because kernfs_dop_revalidate gets the dentry
whose dentry->d_lockref.count is elevated. Reclaim specifically skips such
dentries.

