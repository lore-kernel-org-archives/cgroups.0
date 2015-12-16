From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/6] cgroup: Remove prohibited white spaces
Date: Wed, 16 Dec 2015 09:22:05 +0800
Message-ID: <5670BCBD.9000804@huawei.com>
References: <1450182045-27480-1-git-send-email-kuba.kunert@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450182045-27480-1-git-send-email-kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Jakub,

On 2015/12/15 20:20, Jakub Kunert wrote:
> This patch fixes the checkpatch.pl error:
>
> ERROR: space prohibited before open square bracket
>

checkpatch.pl should be used to check patches that are going to be
sent to the mailing list, and normally should not be used to check
againt existing code.
