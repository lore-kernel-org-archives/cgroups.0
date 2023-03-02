From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/1] psi: remove 500ms min window size limitation for
 triggers
Date: Thu, 2 Mar 2023 12:58:57 -0500
Message-ID: <ZADj4YX4uftK/Frh@cmpxchg.org>
References: <20230301193403.1507484-1-surenb@google.com>
 <Y/+wlg5L8A1iebya@cmpxchg.org>
 <CAJuCfpHhA4XpoE96u5CPktDcSChUkQG_Ax58NzJOiOoF2K+3qQ@mail.gmail.com>
 <ZADBCEk68W1aGJAV@cmpxchg.org>
 <CAJuCfpHF=9Dv_Yzph5jNmR1ZfTf7Lf=_oShztyLUq0ps_D=osQ@mail.gmail.com>
 <ZADf27Kx5mbFev+I@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1677779939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WPFA+ANTHDEBDLlZRcRzWYR3HIDFousSy5BF6H/rVWk=;
        b=naATl86IWiASMsZEMEtqQ+PD07Qk9nnv5YUVcaW9FQIJfbmh/SqrKAZaAlTStOXBfs
         VpyJQjWkV1J7R9kthjOZdY/Li2litcV+POzFGN5H+fy2Y+QgqhNWcBXzsZLVVNfsTfXl
         xVxQ4YLBBlAJB8mZiu72uw0Jcs68wd8oAFrs9UOpmVFgBLp9oGQEB4H1aTC5ImPGaNMI
         QmD5pw9MRANsc6w3P7ZBQb4/izMDCzPX+WYFfuP5NgTpwOvThB8vj+H8kDO3pgw2BoME
         71dhCM5qsABYq5QZ7pUSshDg0IMq81sR9yvhpSZiXSz7SNr51GPtJzSl2czZCB1tl81s
         RP+w==
Content-Disposition: inline
In-Reply-To: <ZADf27Kx5mbFev+I-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 02, 2023 at 06:41:47PM +0100, Michal Hocko wrote:
> On Thu 02-03-23 08:13:54, Suren Baghdasaryan wrote:
> [...]
> > Let's roll this check without additional changes and then consolidate
> > the checking inside psi_trigger_create() in a separate patch. If
> > anybody objects to the late permission check we will just revert that
> > last change without affecting anything else.
> 
> Permissions checks at write time are problematic because userspace
> cannot drop privileges. Also I think it would be an antipattern for how
> we do this in general. 

The permissions can be checked against opener privileges through
file->f_cred. This allows dropping privileges, as well as passing the
fd to a trusted but unprivileged process to delegate trigger setup.

I agree with keeping it in open() for now. But it will matter when we
distinguish between privileged and unprivileged trigger parameters.
