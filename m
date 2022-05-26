From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] psi: dont alloc memory for psi by default
Date: Thu, 26 May 2022 12:10:05 -0400
Message-ID: <Yo+mXVefsRSxjTMY@cmpxchg.org>
References: <20220526122656.256274-1-chenwandun@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lDIN0F8mvUcIGsiOah6JCrzsC64603zfSeEz/dKmMio=;
        b=olZ/4QEjQFmPMP59XTnjcoZ/IIDwnh9ZjBNh4mITNRa2SGio88rIvmn77mWSmsyhnS
         1+My7HsltQdc2zU6sKYLAIOvlxtEKbLNq2RZTXfRw0rh+WjeBDqAoOQ7QuUvnqwko4zG
         Bp7b8/ThHTGaoJx7noACCWKr7TdO/piuRapEvKlkkx65IDM6tZN7NCywfKkjvdid0Gzh
         jYLbsfouWZFQoOxa4OaCfLwhg7wXO1UtTCzjzuaZ0+6TmoEwsfvfyl3vi7ZpufE2/uSf
         7U9QTSX8VJbSStJcKOUtySPIl/D9jnDea58T6Pa7IWCpmu/uPqbo0d0KPakyfxrK3MrG
         W8bw==
Content-Disposition: inline
In-Reply-To: <20220526122656.256274-1-chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 26, 2022 at 08:26:56PM +0800, Chen Wandun wrote:
> Memory about struct psi_group is allocated by default for
> each cgroup even if psi_disabled is true, in this case, these
> allocated memory is waste, so alloc memory for struct psi_group
> only when psi_disabled is false.
> 
> Signed-off-by: Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Looks good to me,
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Tejun, would you mind taking this through the cgroup tree?
