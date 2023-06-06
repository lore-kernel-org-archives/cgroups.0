From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: Re: [PATCH] Documentation: Clarify usage of memory limits
Date: Tue, 6 Jun 2023 09:09:50 -0400
Message-ID: <ZH8wHva5/8n1EJv0@dschatzberg-fedora-PC0Y6AEN>
References: <20230601183820.3839891-1-schatzberg.dan@gmail.com>
 <ZH55K79CaSD6Zya1@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686056993; x=1688648993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=33ubNGnlWzb0zUgKXOo7PameOxfWs466JIL20ejCxRU=;
        b=YLInumMaJo4nCJrIXzReQU0BlvN7m/0+3WtFgkqlPKn6GyR1fIwy2krQvMzHNjBGH1
         Y68DUYUasgdDYG/uqY+QQR0cx+AWlJ90UMPDSrj03K7ZPH/Vcg+7r/ioR4jNrittWwJV
         OWXP2/8dAEQaaQnInokesrQdcEBGKe0kDdwzHAOP972bTAcmV3T0+h9xvzx/JmmslsqT
         WyYU75DQR0D7ifiPW7k56WL7/LxxgAn5oHOrj6CtGzvZpuIl0Hoo169ua5O1ja5QvQvo
         +mKDM5pGvxu/FO4dEtgsRgQq8OX00FRaGyrOm/XI0oC/+XGwwQ1XXsu/XVNuyfhRCFnr
         Lfrw==
Content-Disposition: inline
In-Reply-To: <ZH55K79CaSD6Zya1@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On Mon, Jun 05, 2023 at 02:09:15PM -1000, Tejun Heo wrote:
> Hello,
>
> ...
> 
> I think it'd be helpful to provide pointers to oomd and systemd's
> implementation of it here.

Yeah, I considered that but didn't see any other external links in
this doc, so it felt out of place. I don't feel strongly, but feel
free to add to the patch and link to oomd
(https://github.com/facebookincubator/oomd) and systemd-oomd
(https://www.freedesktop.org/software/systemd/man/systemd-oomd.service.html)
