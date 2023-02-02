From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] fscrypt: Copy the memcg information to the ciphertext
 page
Date: Thu, 2 Feb 2023 11:30:42 -1000
Message-ID: <Y9wrglzrfzTiCjh8@slm.duckdns.org>
References: <20230129121851.2248378-1-willy@infradead.org>
 <Y9a2m8uvmXmCVYvE@sol.localdomain>
 <Y9bkoasmAmtQ2nSV@casper.infradead.org>
 <Y9mH0PCcZoGPryXw@slm.duckdns.org>
 <Y9oHQ6MfRbfwmFyK@sol.localdomain>
Mime-Version: 1.0
Return-path: <linux-ext4-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nrz3TSmcgrSpTyZCmW79h4FBugW4tEaSs53yJ16o+LY=;
        b=EEWpC85Vt6Nu9fYfzP562UwxgqEfKGDl+Svi44sV6+yCnSHoJaS5NtrLqfIY5P3Mta
         xzu7914vju2do7ooaEpdLyCJFOPe1YtRoXLOhvrSWoTw/XqN+Pakt0t7I1nsWreEZgif
         5L0/iFVQnExE645NHL6Nz6upvotE/mY94j1kjr/To9E80Yzxuac8JGv6w05Iy0Ozx1ev
         iNwrsUJ12hpCriwk28MItcJtsvVib34zGVBLKQT6dQl3MXbsHw19dJrjarP+3DErMzVN
         sTvfSBLMm1JhY4jnyRwr/iiGBO9Kn0TJMrDkTUrkeEhH5Q+LkJ3Oy/Xl7fsQhIpbbylX
         /0cw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <Y9oHQ6MfRbfwmFyK@sol.localdomain>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Tue, Jan 31, 2023 at 10:31:31PM -0800, Eric Biggers wrote:
> > These can usually be handled by explicitly associating the bio's to the
> > desired cgroups using one of bio_associate_blkg*() or
> > bio_clone_blkg_association().
> 
> Here that already happens in wbc_init_bio(), called from io_submit_init_bio() in
> fs/ext4/page-io.c.

Yeah, without bouncing, that's usually how writeback IOs are associated with
their cgroups.

> > It is possible to go through memcg ownership
> > too using set_active_memcg() so that the page is owned by the target cgroup;
> > however, the page ownership doesn't directly map to IO ownership as the
> > relationship depends on the type of the page (e.g. IO ownership for
> > pagecache writeback is determined per-inode, not per-page). If the in-flight
> > pages are limited, it probably is better to set bio association directly.
> 
> ext4 also calls wbc_account_cgroup_owner() for each pagecache page that's
> written out.  It seems this is for a different purpose -- it looks like the
> fs-writeback code is trying to figure out which cgroup "owns" the inode based on
> which cgroup "owns" most of the pagecache pages?

Yeah, there's a difference between how memory and IO track cgroup ownership.
Memory ownership is per-page but IO ownership is per-inode. This is because
splitting writeback IOs of the same inode can perform really badly, so we
try to find the majority dirty page owner cgroup of a given inode and
associate the whole inode to that cgroup.

So, something like md / dm, which gets a bio from filesystem and then
bounces it to another bio, would use either bio_clone_blkg_association() to
copy the association of the original bio (which probably is set through
wbc_init_bio()) or determine the cgroup the bio should belong to somehow and
set it explicitly with bio_associate_blkg(). However, here, as the
filesystem is the one bouncing I guess it can be simpler.

> The bug we're discussing here is that when ext4 writes out a pagecache page in
> an encrypted file, it first encrypts the data into a bounce page, then passes
> the bounce page (which don't have a memcg) to wbc_account_cgroup_owner().  Maybe
> the proper fix is to just pass the pagecache page to wbc_account_cgroup_owner()
> instead?  See below for ext4 (a separate patch would be needed for f2fs):

Yeah, this makes sense to me and is the right thing to do no matter what.
wbc_account_cgroup_owner() should be fed the origin page so that the IO can
be blamed on the owner of that page.

Thanks.

-- 
tejun
