From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH 0/4] Track exported dma-buffers with memcg
Date: Thu, 12 Jan 2023 09:17:21 +0100
Message-ID: <2df3c97f-9e54-e743-a29f-f20f5461c851@amd.com>
References: <20230109213809.418135-1-tjmercier@google.com>
 <CALvZod4ru7F38tAO-gM9ZFKaEhS0w3KqFbPwhwcTvgJs4xMUow@mail.gmail.com>
 <Y78+rfzXPq5XGs9O@phenom.ffwll.local>
 <CABdmKX0TAv=iRz0s+F6dVVX=xsK00BeUPkRM4bnsfemDAY9U4w@mail.gmail.com>
 <20230112081337.fxgnhdk44mxu26et@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhpZ6TmtUE/4qtDH4tuv1gmdSIFfJVCkGumJ+omqkEQ=;
 b=rbV7JbG+YtA0jU1tnlzDCnp6b4kM8kHW6DMywXCC5+xAgbJdC03e0d2lfVKX1ULBpEc67EbskjTu31VKSUmZ2H2HEj5p4KS4pDEsyPG9AJV9Gl2KjRfOLuEEswv3B1L8wzl10SU/B2WmE8tbRIpUQ3t0ABfLjJld3pJnGouvMSE=
Content-Language: en-US
In-Reply-To: <20230112081337.fxgnhdk44mxu26et-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "Serge E. Hallyn" <ser>

Am 12.01.23 um 09:13 schrieb Shakeel Butt:
> On Wed, Jan 11, 2023 at 04:49:36PM -0800, T.J. Mercier wrote:
> [...]
>>> The problem is a bit that with gpu allocations reclaim is essentially "we
>>> pass the error to userspace and they get to sort the mess out". There are
>>> some exceptions (some gpu drivers to have shrinkers) would we need to make
>>> sure these shrinkers are tied into the cgroup stuff before we could enable
>>> charging for them?
>>>
>> I'm also not sure that we can depend on the dmabuf being backed at
>> export time 100% of the time? (They are for dmabuf heaps.) If not,
>> that'd make calling the existing memcg folio based functions a bit
>> difficult.
>>
> Where does the actual memory get allocated? I see the first patch is
> updating the stat in dma_buf_export() and dma_buf_release(). Does the
> memory get allocated and freed in those code paths?

Nope, dma_buf_export() just makes the memory available to others.

The driver which calls dma_buf_export() is the one allocating the memory.

Regards,
Christian.
