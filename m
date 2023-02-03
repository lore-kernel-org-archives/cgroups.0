From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] fscrypt: Copy the memcg information to the ciphertext
 page
Date: Thu, 2 Feb 2023 17:07:24 -0800
Message-ID: <Y9xeTDOmMZ75G6cq@sol.localdomain>
References: <20230129121851.2248378-1-willy@infradead.org>
 <Y9a2m8uvmXmCVYvE@sol.localdomain>
 <Y9bkoasmAmtQ2nSV@casper.infradead.org>
 <Y9mH0PCcZoGPryXw@slm.duckdns.org>
 <Y9oHQ6MfRbfwmFyK@sol.localdomain>
 <Y9wrglzrfzTiCjh8@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675386446;
        bh=fz7m0oNp3+iBydgkgnlasJNzPQcxkPq6HJHHFp/eDmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rOPBW7zi68EwVAEdF7hysr6oZSetdbFyWDQ38pu9afuQOyIaPfIj+GPMbinOGVKwF
         jOpH9BpW+bFA8vk7Oz4cWWpqnAqwPG7tuOwazTT8kOuxLoXmnkIa0biz8NiC8WUZfa
         NKuoTC94VJ+yKXU7LXEvM8Irk+XI3Mjv332MA4lkEK0Hqeyk7CSKdtUDdl/kqRWCGQ
         MbybtQGZhULhNZV0MFyzvrt8AOHC1Ggpkq2BaXFEA0/oNk8H6zxXUFJ64hcx5eS5OC
         MDxra6w/3V4tQGiLhEIhmdYs8ky9b8YHTMa4Rzj2vL9clXunI18/XZsl6ugnW/lVbd
         KSk8JF2n/4nFw==
Content-Disposition: inline
In-Reply-To: <Y9wrglzrfzTiCjh8@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org, cgroups@vger.kernel.org

On Thu, Feb 02, 2023 at 11:30:42AM -1000, Tejun Heo wrote:
> > The bug we're discussing here is that when ext4 writes out a pagecache page in
> > an encrypted file, it first encrypts the data into a bounce page, then passes
> > the bounce page (which don't have a memcg) to wbc_account_cgroup_owner().  Maybe
> > the proper fix is to just pass the pagecache page to wbc_account_cgroup_owner()
> > instead?  See below for ext4 (a separate patch would be needed for f2fs):
> 
> Yeah, this makes sense to me and is the right thing to do no matter what.
> wbc_account_cgroup_owner() should be fed the origin page so that the IO can
> be blamed on the owner of that page.

Thanks.  These patches fix this for ext4 and f2fs:

    * https://lore.kernel.org/r/20230203005503.141557-1-ebiggers@kernel.org
    * https://lore.kernel.org/r/20230203010239.216421-1-ebiggers@kernel.org

- Eric
