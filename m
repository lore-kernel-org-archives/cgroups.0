From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Tue, 10 Dec 2013 17:03:45 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com> <20131127163435.GA3556@cmpxchg.org> <20131202200221.GC5524@dhcp22.suse.cz> <20131202212500.GN22729@cmpxchg.org> <20131203120454.GA12758@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312031544530.5946@chino.kir.corp.google.com> <20131204111318.GE8410@dhcp22.suse.cz> <alpine.DEB.2.02.1312041606260.6329@chino.kir.corp.google.com> <20131209124840.GC3597@dhcp22.suse.cz> <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com>
 <20131210103827.GB20242@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=iQUQfi9fgqRWmagtmNL7GNZQVF73NCyVjbelZw/bU2Q=;
        b=V+EDGmgDkLTmEFRO69GzhiFsytMpiicaLFRx1NQgbT59TM3jIJ6hZDDkNJbiCpF6Av
         HK/wpduymRk5xMxCdyAq240LbkL31mu01xe/P7NSMnBIl4CTLF5KVUrqZrbU7Mu330Rr
         QlJu4qjGUCZMIUCsbkrDlZ7ivLrl5IQUBs6RRNrph1POwtDbahlOcIXAEOGqJRzyEPs9
         iUtn3lV1yjGwJNGcr28yyAVjtK7X1375AE2IFA/V1MFS70a4k0b8vlwAei3Lh4xa8/BK
         WDseUGN+9v4XCRmewf3WrvuAJvsVheNQei8r9tCRwWE+3D0b6OCNovlRhHh66hoEMLH0
         DUGw==
In-Reply-To: <20131210103827.GB20242-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 10 Dec 2013, Michal Hocko wrote:

> > What exactly would you like to see?
> 
> How often do you see PF_EXITING tasks which haven't been killed causing
> a pointless notification? Because fatal_signal_pending and TIF_MEMDIE
> cases are already handled because we bypass charges in those cases (except
> for user OOM killer killed tasks which don't get TIF_MEMDIE and that
> should be fixed).
> 

Triggering a pointless notification with PF_EXITING is rare, yet one 
pointless notification can be avoided with the patch.  Additionally, it 
also avoids a pointless notification for a racing SIGKILL.
