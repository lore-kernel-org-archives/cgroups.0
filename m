From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Wed, 23 Jul 2014 20:08:57 +0200
Message-ID: <CAJfpegs-k5QC+42SzLKUSaHrdPxWBaT_dF+SOPqoDvg8h5p_Tw@mail.gmail.com>
References: <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
	<20140715082545.GA9366@dhcp22.suse.cz>
	<20140715121935.GB9366@dhcp22.suse.cz>
	<20140718071246.GA21565@dhcp22.suse.cz>
	<20140718144554.GG29639@cmpxchg.org>
	<CAJfpegt9k+YULet3vhmG3br7zSiHy-DRL+MiEE=HRzcs+mLzbw@mail.gmail.com>
	<20140719173911.GA1725@cmpxchg.org>
	<20140722150825.GA4517@dhcp22.suse.cz>
	<CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA@mail.gmail.com>
	<20140723143847.GB16721@dhcp22.suse.cz>
	<20140723150608.GF1725@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Ugn8HeEdg1itFy9lwTRalVoXWhIz1Q/gPEd2xmywLhw=;
        b=kyfY2AfHIVHTW/SGBTeFA3DVbg08/0pmLZLV/61qAfGHIpZbzxPmrFy95F8q23cfPF
         Jc1bf0BW4ZhPThSd83E9QjE1WrBadV0rDCrdqcs4MAY+e8ezwZ3o/eXgbgQGzjqhxs1t
         RgWpKIVs5YL6L+czo5umnB1aaVLcJivMeQ6sQ=
In-Reply-To: <20140723150608.GF1725@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, Jul 23, 2014 at 5:06 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Can the new page be anything else than previous page cache?

It could be an ordinary pipe buffer too.  Stealable as well (see
generic_pipe_buf_steal()).

Thanks,
Miklos

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
