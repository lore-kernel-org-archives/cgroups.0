From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: Do not high throttle allocators based on
 wraparound
Date: Tue, 31 Mar 2020 16:25:34 +0100
Message-ID: <20200331152534.GA972283@chrisdown.name>
References: <20200331152424.GA1019937@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YTzVrLlnv/U861L9j2OH30y80LBa/uThEvzXvP/gh2c=;
        b=MX3SlhqtOgu7+xXPL0VtCywalercn8WvcRrstjEE7UrqsuB7MOfCn54non2gPg5X59
         uLet+fnVhtkcLmoWl91/g5RA8oxVdZsQT8JOjXegkF08l25QW2YHmBU2fGuolcm2oQCG
         THSGdBz4PAgk6GtfOmO2lXmtTDQFqofruA8cA=
Content-Disposition: inline
In-Reply-To: <20200331152424.GA1019937-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Andrew, this is a pretty bad one that could definitely affect memory.high 
users. We should probably expedite it going in.

Sorry for the trouble, especially on a -stable patch...
