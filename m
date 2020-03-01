From: Marco Ballesio <balejs-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup-v1: freezer: optionally killable freezer
Date: Sun, 1 Mar 2020 08:20:03 -0800
Message-ID: <20200301162003.GA186618@google.com>
References: <20200219183231.50985-1-balejs@google.com>
 <20200229005131.GB9813@google.com>
 <20200229184300.GA484762@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ol996i7Ly7uLXMGPOcxJk9a2/P7UfTmFHb83woUuOo4=;
        b=BmBgW1BXpb61N9UVhWc3UCobtjZmRY8cfjAit8K3GJNut56umMykryyzI9AzxVCNPu
         zOEVDsY3sT4UDzTHMxTNl9cA7M9jDoCm9XTPeWxZcTzpfVvX/4GlQyjehDQw0YtTjoWL
         EB9DXjWAslee7XYEPpiMDSk/CpSA8B7PG1YgEGGc+U8RJWtG64RB7rrOGqzA7b4rQS5s
         omthZP5UEN5t/YqPCx4Z7BD6vT2yjRFsX2lYXKeIaPmSzb2BFnmgmLEeGuprZ4xHPtlk
         MsDaZbTpDj609q6Y8zXZ0uP9KGKGRdg1t2ky59PPhmZPGZJqesifD/zmyl5NnA3qyDyZ
         FcaA==
Content-Disposition: inline
In-Reply-To: <20200229184300.GA484762-lLJQVQxiE4uLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, minchan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Sat, Feb 29, 2020 at 10:43:00AM -0800, Roman Gushchin wrote:
> On Fri, Feb 28, 2020 at 04:51:31PM -0800, Marco Ballesio wrote:
> > Hi all,
> > 
> > did anyone have time to look into my proposal and, in case, are there
> > any suggestions, ideas or comments about it?
> 
> Hello, Marco!
> 
> I'm sorry, somehow I missed the original letter.
> 
> In general the cgroup v1 interface is considered frozen. Are there any particular
> reasons why you want to extend the v1 freezer rather than use the v2 version of it?
> 
> You don't even need to fully convert to cgroup v2 in order to do it, some v1
> controllers can still be used.
> 
> Thanks!
> 
> Roman

Hi Roman,

When compared with backports of v2 features and their dependency chains, this
patch would be easier to carry in Android common. The potential is to have
killability for frozen processes on hw currently in use.

Marco
