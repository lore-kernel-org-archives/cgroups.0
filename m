From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [Patch v2] mm: thp: grab the lock before manipulation defer list
Date: Tue, 14 Jan 2020 13:31:12 +0300
Message-ID: <20200114103112.o6ozdbkfnzdsc2ke@box>
References: <20200109143054.13203-1-richardw.yang@linux.intel.com>
 <20200111000352.efy6krudecpshezh@box>
 <20200114093122.GH19428@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gH2onGwJqIgSVIVO9iF6x/48+kAkgINLPogWn+IxdXo=;
        b=CWwvQIMaFeGbGcccImhlvs+GWFEMa+s41DfLTdi1dEYXmM/c9ttvKpEVFZ3dqVHpAZ
         J1ZSto4Ma/A2rGpMzgBYWcSOtodiUWd8S/F3Qs5FtRli34jgB7d8FirhpsFA09NtKmiL
         7wggFVGtiFPUYJIFhzWaKeeGtyqMEDkyRMWSqSJBQzTt3IG/infOvP9BWGKVH9rGn/k0
         yXN0lMiLBlXfnNRVSj6EykH/yYhTGG3+qiiJ7+LK9ocNN9jYW+lId5t9wGBLib03Lyv/
         J4G7pK3IEIDviBleMQLqtKlxPxv0OcSo4pVcwadkegBN/Uwrg3xsYNLaBTHmyFqcX+uh
         ut3Q==
Content-Disposition: inline
In-Reply-To: <20200114093122.GH19428@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, alexander.duyck@gmail.com, rientjes@google.com

On Tue, Jan 14, 2020 at 10:31:22AM +0100, Michal Hocko wrote:
> On Sat 11-01-20 03:03:52, Kirill A. Shutemov wrote:
> > On Thu, Jan 09, 2020 at 10:30:54PM +0800, Wei Yang wrote:
> > > As all the other places, we grab the lock before manipulate the defer list.
> > > Current implementation may face a race condition.
> > > 
> > > For example, the potential race would be:
> > > 
> > >     CPU1                      CPU2
> > >     mem_cgroup_move_account   split_huge_page_to_list
> > >       !list_empty
> > >                                 lock
> > >                                 !list_empty
> > >                                 list_del
> > >                                 unlock
> > >       lock
> > >       # !list_empty might not hold anymore
> > >       list_del_init
> > >       unlock
> > 
> > I don't think this particular race is possible. Both parties take page
> > lock before messing with deferred queue, but anytway:
> > 
> > Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> 
> I am confused, if the above race is not possible then what would be a
> real race? We really do not want to have a patch with a misleading
> changelog, do we?

The alternative is to make sure that all page_deferred_list() called with
page lock taken.

I'll look into it.

-- 
 Kirill A. Shutemov

