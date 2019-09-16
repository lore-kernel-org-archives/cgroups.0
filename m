From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/1] block, bfq: remove bfq prefix from cgroups filenames
Date: Mon, 16 Sep 2019 08:16:43 -0700
Message-ID: <20190916151643.GC3084169@devbig004.ftw2.facebook.com>
References: <20190909073117.20625-1-paolo.valente@linaro.org>
 <80C56C11-DA21-4036-9006-2F459ACE9A8C@linaro.org>
 <c67c4d4b-ee56-85c1-5b94-7ae1704918b6@kernel.dk>
 <1F3898DA-C61F-4FA7-B586-F0FA0CAF5069@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=to+g4mrtJdYUkTxkKpAQLy9ttRtsAGqphpzLEO+R2Do=;
        b=k3p4HOtMQrmIbyPz6c5OGR6zKDjk6SwAb5skOSk/70p9X2AUBOqKiVnERofdCGPvuJ
         7XnTCfIUqMbB3GzGT1Rg65tIWDWtrk2EXIRNbvneDZr/lEf92aZYvOj8jDZ8p7wwBEeu
         GzW6Aq+SjNLt94jtH/6A5G+YbVYn5gVzdCIeQdm9ZPp0Aktgy6faZZ7MWjYa5u4Je8IA
         Fgo2vfXKBCI1Y3FEj3C0SqYrKonhjy7OOgrE3uURHf3LQvDoqInFGe4VAVJY6eLxscTQ
         wycQv3/vorliAMyMGOgfwBuTi06Mg7WIFkESkzCwCkAsT2VZ7Jb37HDenfbipCvrglYR
         /rQw==
Content-Disposition: inline
In-Reply-To: <1F3898DA-C61F-4FA7-B586-F0FA0CAF5069@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, cgroups@vger.kernel.org

Hello, Paolo.

On Mon, Sep 16, 2019 at 05:07:29PM +0200, Paolo Valente wrote:
> Tejun, could you put your switch-off-io-cost code into a standalone
> patch, so that I can put it together with this one in a complete
> series?

It was more of a proof-of-concept / example, so the note in the email
that the code is free to be modified / used any way you see fit.  That
said, if you like it as it is, I can surely prep it as a standalone
patch.

Thanks.

-- 
tejun
