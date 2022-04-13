From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next 00/11] support concurrent sync io for bfq on a
 specail occasion
Date: Wed, 13 Apr 2022 13:12:16 +0200
Message-ID: <20220413111216.npgrdzaubsvjsmy3@quack3.lan>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649848336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ngB0VaDZkffeOh+BSwJSCsqMcNibSRUO4jU8FKml6Bs=;
        b=i8qKj0NNFnGDs/62UlAmcsdLiT3oYBGGKRDyTKuXoGgeqCfro+kOFHFEtUEnkuXMb9nrfZ
        jsOai74lku4/r+dmPZLZkCSpMSx3PL33g3X0PyDW/EOZWGk9rEXFvoS8UkeuIHLitPT1b5
        ViZOs9dic+cSfwyRWq1RVGDSWUAlQGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649848336;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ngB0VaDZkffeOh+BSwJSCsqMcNibSRUO4jU8FKml6Bs=;
        b=haFT45FMpnXW+0MzW9Ui1fMZNh/llnnI3l08AdD/0HoufaBvM07pNwAHzWzodylCXdQXTp
        kTc795IgiNJSZQBA==
Content-Disposition: inline
In-Reply-To: <20220305091205.4188398-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat 05-03-22 17:11:54, Yu Kuai wrote:
> Currently, bfq can't handle sync io concurrently as long as they
> are not issued from root group. This is because
> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
> bfq_asymmetric_scenario().
> 
> This patchset tries to support concurrent sync io if all the sync ios
> are issued from the same cgroup:
> 
> 1) Count root_group into 'num_groups_with_pending_reqs', patch 1-5;

Seeing the complications and special casing for root_group I wonder: Won't
we be better off to create fake bfq_sched_data in bfq_data and point
root_group->sched_data there? AFAICS it would simplify the code
considerably as root_group would be just another bfq_group, no need to
special case it in various places, no games with bfqg->my_entity, etc.
Paolo, do you see any problem with that?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
