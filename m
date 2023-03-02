From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/1] psi: remove 500ms min window size limitation for
 triggers
Date: Thu, 2 Mar 2023 18:41:47 +0100
Message-ID: <ZADf27Kx5mbFev+I@dhcp22.suse.cz>
References: <20230301193403.1507484-1-surenb@google.com>
 <Y/+wlg5L8A1iebya@cmpxchg.org>
 <CAJuCfpHhA4XpoE96u5CPktDcSChUkQG_Ax58NzJOiOoF2K+3qQ@mail.gmail.com>
 <ZADBCEk68W1aGJAV@cmpxchg.org>
 <CAJuCfpHF=9Dv_Yzph5jNmR1ZfTf7Lf=_oShztyLUq0ps_D=osQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677778908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BxNVxQxpUa9EQo7tVoxpRgg3ciw7b1eHgoO8lDNIC4g=;
        b=sRSXGveL2AxhYFLe9CL6gEeYCvl9WiMlJb1JB6ba2xNlKm3NIYjul+j63hydUrBXrBsWH8
        jS4XB5rta541t3pGOeXW3wZVJBd6ZnvYmZXdTfeYKZPmKyo8ILT8HZ9LH7OqGsOCPzKPs2
        h704ERv8SZ/bl/SRJYsneFT5PXFiT9E=
Content-Disposition: inline
In-Reply-To: <CAJuCfpHF=9Dv_Yzph5jNmR1ZfTf7Lf=_oShztyLUq0ps_D=osQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 02-03-23 08:13:54, Suren Baghdasaryan wrote:
[...]
> Let's roll this check without additional changes and then consolidate
> the checking inside psi_trigger_create() in a separate patch. If
> anybody objects to the late permission check we will just revert that
> last change without affecting anything else.

Permissions checks at write time are problematic because userspace
cannot drop privileges. Also I think it would be an antipattern for how
we do this in general. 
-- 
Michal Hocko
SUSE Labs
