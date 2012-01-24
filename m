From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC 0/4] per-namespace allowed filesystems list
Date: Tue, 24 Jan 2012 14:32:07 +0400
Message-ID: <4F1E88A7.4000401@parallels.com>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com> <20120123211218.GF23916@ZenIV.linux.org.uk> <20120123230457.GA14347@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120123230457.GA14347-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On 01/24/2012 03:04 AM, Kirill A. Shutemov wrote:
> On Mon, Jan 23, 2012 at 09:12:19PM +0000, Al Viro wrote:
>> This is bloody ridiculous; if you want to prevent a luser adming playing with
>> the set of mounts you've given it, the right way to go is not to mess with the
>> "which fs types are allowed" but to add a per-namespace "immutable" flag.
>> And add a new clone(2)/unshare(2) flag, used only along with the CLONE_NEWNS
>> and setting the "immutable" on the copied namespace.
>
> How will it work if we want to allow namespaced environment to mount block
> devices, but not, let say, debugfs?
>

For the record, that is more or less what I have in mind. But my main 
use case is /proc. I guess the case for debugfs is the same.
