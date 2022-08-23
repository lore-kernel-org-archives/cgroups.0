From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: oomd with 6.0-rc1 has ridiculously high memory pressure stats wit
Date: Tue, 23 Aug 2022 10:12:08 -1000
Message-ID: <YwU0mLBMuxpZ7Zwq@slm.duckdns.org>
References: <d0df567c-1f6a-418d-8db7-3f777bd109c8@www.fastmail.com>
 <YwUcGvE/rhHEZ+KO@slm.duckdns.org>
 <9412f39b-9ec1-4542-944c-19577a358b97@www.fastmail.com>
 <0a6105f9-012a-4b75-b741-6549d7e169d8@www.fastmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=5P2IYFXnBuqEEpc4CpdxE08u3EYHqSr7NM2nRc/y1Cs=;
        b=piey8fd81RjOiCoeeNAbIC9004Ti19DiEvR3H3xP2IKRlfMGEiQErifqfbBA4Imq0Q
         STVuCTaeYOQNB7IKOUYmxIPWKX42dEChsCUUvSIVp10G4WgCmpX+BZ2DWXNpM85E7Mxf
         bH0VtQ2YJZJfNZ1kHoyOqTOWJToEyXUgJpPhP2NbIoOicyZejil30mCzfHfwg51M+e2n
         SaWQrRjOUdy+qjYQSu5TP/HNwmGzBwDmKNRRr95C1NOobQZ4miB2kOQR5NjdwsRFf7Sx
         Bm7SlDajcKzynKbQR9H8fGWH6nPkO/XmlL4iohsSNyg+zBBIH2KO06UWw7F22QKSA5fX
         fAaQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0a6105f9-012a-4b75-b741-6549d7e169d8-jFIJ+Wc5/Vo7lZ9V/NTDHw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Murphy <lists-zXQU9YWDTqjmlV4oE/1sFAC/G2K4zDHf@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue, Aug 23, 2022 at 02:59:29PM -0400, Chris Murphy wrote:
> Same VM but a different boot:
> 
> Excerpts:
> 
> /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/gvfs-goa-volume-monitor.service/io.pressure:some avg10=3031575.41 avg60=56713935870.67 avg300=624837039080.83 total=18446621498826359
> /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/gvfs-goa-volume-monitor.service/io.pressure:full avg10=3031575.41 avg60=56713935870.80 avg300=624837039080.99 total=16045481047390973
> 
> None of that seems possible.
> 
> io is also affected:
> 
> /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/org.gnome.SettingsDaemon.Smartcard.service/io.pressure:full avg10=0.00 avg60=0.13 avg300=626490311370.87 total=16045481047397307
> 
> # oomctl
> # grep -R . /sys/fs/cgroup/user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/
> https://drive.google.com/file/d/1JoUxjQ2ribDvn5jmydCWXJdg0daaNScG/view?usp=sharing
> 
> We're going to try reverting 5f69a6577bc33d8f6d6bbe02bccdeb357b287f56 and see if it helps.

Can you see whether the following helps?

Thanks.

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index ec66b40bdd40..00d62681ea6a 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -957,7 +957,7 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
 	if (static_branch_likely(&psi_disabled))
 		return 0;
 
-	cgroup->psi = kmalloc(sizeof(struct psi_group), GFP_KERNEL);
+	cgroup->psi = kzalloc(sizeof(struct psi_group), GFP_KERNEL);
 	if (!cgroup->psi)
 		return -ENOMEM;
 
