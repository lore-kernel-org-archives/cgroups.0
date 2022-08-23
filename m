From: "Chris Murphy" <lists-zXQU9YWDTqjmlV4oE/1sFAC/G2K4zDHf@public.gmane.org>
Subject: Re: oomd with 6.0-rc1 has ridiculously high memory pressure stats wit
Date: Tue, 23 Aug 2022 14:59:29 -0400
Message-ID: <0a6105f9-012a-4b75-b741-6549d7e169d8@www.fastmail.com>
References: <d0df567c-1f6a-418d-8db7-3f777bd109c8@www.fastmail.com>
 <YwUcGvE/rhHEZ+KO@slm.duckdns.org>
 <9412f39b-9ec1-4542-944c-19577a358b97@www.fastmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        colorremedies.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1661281199; x=
        1661284799; bh=GABU8m9X+3Sbt6EutiL3q4wNZa+NudfPpXTG5PFEDEc=; b=J
        VxHbywQ9/0IUpy/f8GElZtPuzY9EYW15iOTJfUdQWjX5cVXQvukm+on0M6GHaTB5
        dEtTbUtHg3NQlJffPC4At51olMDDZPSRMy/iJVJPGyxd9QonI1ca89oSFLa3UP7v
        nQWAy6puroP6HRzmzoy5V7ocWVlvV4vNKDyWAbAgE0jB2ZsZ+Q9Ue4a4Ma37XMZc
        DCumZrd9sYwbJNttHCUJIgww6N1DHJEsSR2qlB8lpVqQocay/3aPSxlv2R0Se0cB
        RVj6PYiGuF4rv/Uhmh2zDNH4saxT7Z+y6u6+I+srEy+2BPk4el1DtFMjjmgfEttC
        Qm2pobhaYl1tvjvvOqeiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1661281199; x=1661284799; bh=GABU8m9X+3Sbt6EutiL3q4wNZa+N
        udfPpXTG5PFEDEc=; b=HAHCAfOxbY2zG0WsV+9hm5E7/FudcY2xPH/uSXt1lwNZ
        Sja+MyN0CPATm0q/YPvWkRaqiCKYXeJVgbRDX281R4FvdWGDwADhgSfjVNwwWviZ
        W+DS7lRA6f5JlM4rQtIH90U4YMSyLm0NECNFqUfP4ivYUUh74Ymy8jn2NluQ4zSd
        Vgu+Xz89XhNEwgCEB2mGKoGGt/8eyDBFPE1LKpyPmANEr0SpdIKIX46+al1XilSJ
        zuc9RtYZ5eBo+N/0OSNXBW+M4zWSW6siSihocAP32yGEG5vPMs1P7LYtdk5Rdr4I
        1+aghiS/Jqo05cfTtaUZu9PnwpMTnippAs7CE/d6Og==
In-Reply-To: <9412f39b-9ec1-4542-944c-19577a358b97-jFIJ+Wc5/Vo7lZ9V/NTDHw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Same VM but a different boot:

Excerpts:

/sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/gvfs-goa-volume-monitor.service/io.pressure:some avg10=3031575.41 avg60=56713935870.67 avg300=624837039080.83 total=18446621498826359
/sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/gvfs-goa-volume-monitor.service/io.pressure:full avg10=3031575.41 avg60=56713935870.80 avg300=624837039080.99 total=16045481047390973

None of that seems possible.

io is also affected:

/sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/org.gnome.SettingsDaemon.Smartcard.service/io.pressure:full avg10=0.00 avg60=0.13 avg300=626490311370.87 total=16045481047397307

# oomctl
# grep -R . /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/
https://drive.google.com/file/d/1JoUxjQ2ribDvn5jmydCWXJdg0daaNScG/view?usp=sharing

We're going to try reverting 5f69a6577bc33d8f6d6bbe02bccdeb357b287f56 and see if it helps.
