From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 01/12] rdmacg: Replace strncmp with str_has_prefix
Date: Thu, 29 Aug 2019 16:52:56 -0700
Message-ID: <201908291652.46E2D65@keescook>
References: <20190729151346.9280-1-hslester96@gmail.com>
 <201907292117.DA40CA7D@keescook>
 <CANhBUQ3V2A-TBVizVh+eMLSi5Gzw5sMBY7C-0a8=-z15qyQ75w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6oTB1dU146xuL9pK4Gwg180KU60SGC31jIorRGs7ptk=;
        b=a250Zfx3hOfWzOHrL5E2dEv/6jxRZA+JbksFHHqddgm0GXvE1i4OV0Ui/sUUwWq9Qz
         4sKMyiAb+MJUEMoErBcXFPrcnPtDT2GaH8lfEelAqVK5nG8PlK407kkkx6hvjFc6VoV9
         U33PcQmOIjjinVTDjaCccNNDE79eJ2UxQkEfA=
Content-Disposition: inline
In-Reply-To: <CANhBUQ3V2A-TBVizVh+eMLSi5Gzw5sMBY7C-0a8=-z15qyQ75w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chuhong Yuan <hslester96@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, Laura Abbott <labbott@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Steven Rostedt <rostedt@goodmis.org>

On Tue, Jul 30, 2019 at 02:39:40PM +0800, Chuhong Yuan wrote:
> I think with the help of Coccinelle script, all strncmp(str, const, len)
> can be replaced and these problems will be eliminated. :)

Hi! Just pinging this thread again. Any progress on this conversion?

Thanks!

-- 
Kees Cook
