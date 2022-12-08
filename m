From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 15/18] cgroup/misc: Add per resource callbacks for css
 events
Date: Thu, 8 Dec 2022 14:53:24 +0000
Message-ID: <Y5H6ZLz7HXSaTF30@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-16-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670511215;
        bh=gNYmD028duyNvaTJtvf/NGBZ2mjD2/rgX8wXO9WiHfY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sD7RMyOzkU97qx+1zhDY0V/GUBCnO/9DYn4xHp6yLY4soGKny4IjRZtNBH6ylYVRT
         wdT07S9bgmuKm4z5qqy6A0RbyQcR6Y/Mo8EahGwb/MSEhdIktLivSA+tRs9E7A/QzJ
         5V1W2aO95TQsa5sHmvq7LXb1M7qQy6PfGmQCYJc0DwHE/zP8or46LDW//uoQ1JnZaB
         6dap3aBye7T6rQ6Q2s+ylr3Hr8lVtOhvzggqn58nvFRyOUdwvxHEG3c9rCDzO8V/IQ
         miQRWws2BkCY4fZl4jcatYQiOLg5d40oHHNiOseHQYNnILKj/Dcb7Uhnmu7LeOvz95
         prfaG30OOluyg==
Content-Disposition: inline
In-Reply-To: <20221202183655.3767674-16-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Fri, Dec 02, 2022 at 10:36:51AM -0800, Kristen Carlson Accardi wrote:
> Consumers of the misc cgroup controller might need to perform separate actions
> in the event of a cgroup alloc, free or release call. In addition,
> writes to the max value may also need separate action. Add the ability
> to allow downstream users to setup callbacks for these operations, and
> call the per resource type callback when appropriate.
> 
> This code will be utilized by the SGX driver in a future patch.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

I don't know what css is.

BR, Jarkko
