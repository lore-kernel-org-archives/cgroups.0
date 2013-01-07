From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] cgroups: fix cgroup_event_listener error handling
Date: Mon, 7 Jan 2013 09:44:27 -0800
Message-ID: <20130107174427.GM3926@htj.dyndns.org>
References: <1357333518-28899-1-git-send-email-gthelen@google.com>
 <1357333518-28899-2-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=CmDues33HwTfJpyVMDTT4Htle+shYkMrgE1lMQi+f0w=;
        b=KsqExcKTqrh6lkA4Xb3L28eETYwD8712OhDlPV736bcpG8H/BKu5oDVOo83rjy3In5
         NPYmad3Na6/3w7Bz4tUGRMLbR/zxiKayS4KQu7FwpYSzcdlgsFtr5ediPBGXYZTHGUw9
         ffP2IJYbyqB8skV2uaImHkCkjci+IB4Ui8zfzebqAXJl/8S9pA2NwGxBYeYisBuOScqW
         lcyJ48aQ3l3P/bImwqm8pWLjou8NarRCJZ+cYcOP0HqDjjlhafQfBVAyBSzaNWS9/Dsz
         o5a2QFH2dDMK3xP51lsn+ksL6i6KymhuoGOg4VMi2MwLy1ehnEOpMcCFBmGOaPgroSnI
         LLvA==
Content-Disposition: inline
In-Reply-To: <1357333518-28899-2-git-send-email-gthelen@google.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Greg Thelen <gthelen@google.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 01:05:18PM -0800, Greg Thelen wrote:
> If the <absolute-path-to-control-file> command line parameter cannot
> be opened, then cgroup_event_listener prints an error message and
> tries to return an error.  However, due to an uninitialized variable
> the return value was undefined.
>=20
> With this patch such failures always return non-zero error.
>=20
> Compiler warning found this:
>   $ gcc -Wall -O2 cgroup_event_listener.c
>   cgroup_event_listener.c: In function =E2=80=98main=E2=80=99:
>   cgroup_event_listener.c:109:2: warning: =E2=80=98ret=E2=80=99 may b=
e used uninitialized in this function [-Wuninitialized]
>=20
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  tools/cgroup/cgroup_event_listener.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/tools/cgroup/cgroup_event_listener.c b/tools/cgroup/cgro=
up_event_listener.c
> index 3e082f9..a70f00c 100644
> --- a/tools/cgroup/cgroup_event_listener.c
> +++ b/tools/cgroup/cgroup_event_listener.c
> @@ -35,7 +35,7 @@ int main(int argc, char **argv)
>  	if (cfd =3D=3D -1) {
>  		fprintf(stderr, "Cannot open %s: %s\n", argv[1],
>  				strerror(errno));
> -		goto out;
> +		return 1;

Hmm... so, event_control open failure path is broken the same way.
Can you please fix it together?  Please just remove the cleanup path.

Thanks.

--=20
tejun
